require 'httparty'
require 'aws-sdk'

PUBLISH_REPORTS_TESTS_FAILED = []

AfterConfiguration do |config|
  config.on_event :after_test_case do |event|
    if not event.result.ok?
      PUBLISH_REPORTS_TESTS_FAILED.push(event.test_case.name)
    end
  end
end

at_exit do
  bucket = ENV['REPORT_BUCKET']
  bucket_region = ENV['REPORT_BUCKET_REGION'] || 'us-east-1'
  report_url = nil
  if bucket && system('allure --help >> /dev/null')
    puts 'Generating allure report and uploading to s3'
    report_url = "http://#{bucket}.s3-website-#{bucket_region}.amazonaws.com/#{URI.escape(BUILD)}'
    system('allure generate --clean reports')
    Dir[File.join(Dir.pwd, 'allure-report/**/*')].each do |file|
      if not File.directory?(file)
        file_name = file.clone
        file_name.sub! File.join(Dir.pwd, 'allure-report/'), ''
        s3 = Aws::S3::Resource.new(region: bucket_region)
        obj = s3.bucket(bucket).object('#{BUILD}/#{file_name}')
        obj.upload_file(file)
        obj.acl.put({ acl: 'public-read' })
      end
    end
  end
  if ENV['PAGERDUTY_ROUTING_KEY'] && PUBLISH_REPORTS_TESTS_FAILED.length > 0
    puts 'Sending test failed alert to PagerDuty'
    payload = {
      :payload => {
        :summary => '#{PUBLISH_REPORTS_TESTS_FAILED.length} #{PROJECT_NAME} test(s) failed',
        :source => '#{PROJECT_NAME}',
        :severity => 'critical',
        :custom_details => 'Failed test(s):\n- #{PUBLISH_REPORTS_TESTS_FAILED.join('\n- ')}'
      },
      :event_action => 'trigger',
      :routing_key => ENV['PAGERDUTY_ROUTING_KEY'],
    }
    if report_url
      payload[:links] = [{
        :href => report_url,
        :text => 'Report for #{BUILD}'
      }]
      puts 'Sending s3 report url to PagerDuty'
    end
    response = HTTParty.post 'https://events.pagerduty.com/v2/enqueue',
                        headers:{ 'Content-Type' => 'application/json"},
                        body: payload.to_json
  end
end

