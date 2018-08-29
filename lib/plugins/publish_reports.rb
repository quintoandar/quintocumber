# frozen_string_literal: true

require 'httparty'
require 'aws-sdk'
require 'json'

tests_failed = []

def pagerduty_payload(failed_length, reports_list_str)
  {
    payload: {
      summary: failed_length.to_s + " #{PROJECT_NAME} test(s) failed",
      source: PROJECT_NAME.to_s,
      severity: 'critical',
      custom_details: "Failed test(s):\n- #{reports_list_str}"
    },
    event_action: 'trigger',
    routing_key: ENV['PAGERDUTY_ROUTING_KEY']
  }
end

AfterConfiguration do |config|
  config.on_event :test_case_finished do |event|
    tests_failed.push(event.test_case.name) unless event.result.ok?
  end
end

def generate_report_and_upload_to_s3
  bucket = ENV['REPORT_BUCKET']
  bucket_region = ENV['REPORT_BUCKET_REGION'] || 'us-east-1'
  return unless bucket && system('allure --help >> /dev/null')
  puts 'Generating allure report and uploading to s3'
  system('allure generate --clean reports')
  upload_report_files_to_s3
  "http://#{bucket}.s3-website-#{bucket_region}.amazonaws.com/" +
    URI.escape(BUILD)
end

def upload_report_files_to_s3
  s3 = instanciate_s3_connector
  Dir[File.join(Dir.pwd, 'allure-report/**/*')].each do |file|
    next if File.directory?(file)
    upload_to_s3(s3, ENV['REPORT_BUCKET'], file)
  end
end

def instanciate_s3_connector
  bucket_region = ENV['REPORT_BUCKET_REGION'] || 'us-east-1'
  Aws::S3::Resource.new(region: bucket_region)
end

def upload_to_s3(s3, bucket, file)
  file_name = file.clone
  file_name.sub! File.join(Dir.pwd, 'allure-report/'), ''
  obj = s3.bucket(bucket).object("#{BUILD}/#{file_name}")
  obj.upload_file(file)
  obj.acl.put(acl: 'public-read')
  puts "Sending #{BUILD}/#{file_name} to #{bucket}"
end

def insert_report_url_on_pagerduty_payload(report_url, payload)
  payload[:links] = [{
    href: report_url,
    text: "Report for #{BUILD}"
  }]
  puts 'Sending s3 report url to PagerDuty'
end

def report_to_pagerduty(report_url, tests_failed)
  return unless ENV['PAGERDUTY_ROUTING_KEY'] && !tests_failed.empty?
  puts 'Sending test failed alert to PagerDuty'
  payload = pagerduty_payload(tests_failed.length, tests_failed.join('\n- '))
  insert_report_url_on_pagerduty_payload(report_url, payload) if report_url
  HTTParty.post 'https://events.pagerduty.com/v2/enqueue',
                headers: { 'Content-Type' => 'application/json' },
                body: payload.to_json
end

def notify_slack(webhook_url, payload)
  HTTParty.post webhook_url.to_s,
                headers: { 'Content-Type' => 'application/json' },
                body: payload.to_json
end

def slack_text(report_url, tests_failed)
  txt = if tests_failed.empty?
          'Success! All tests passed.'
        else
          "Failure! There are #{tests_failed.length} failed tests: "\
          "\n\t#{tests_failed.join("\n\t")}"\
        end
  txt
end

def slack_pretext(report_url)
  pretext = if report_url
              "Full report at #{report_url}"
            else
              'Report was not published.'
            end
  pretext
end

def slack_color(tests_failed)
  color = if tests_failed.empty?
            'good'
          else
            'danger'
          end
  color
end

def slack_payload(report_url, tests_failed)
  {
    attachments: [
      pretext: slack_pretext(report_url),
      text: slack_text(report_url, tests_failed),
      color: slack_color(tests_failed)
    ]
  }
end

def report_to_slack(report_url, tests_failed)
  return unless ENV['SLACK_WEBHOOK_URL']
  puts 'Sending test report link to Slack'
  payload = slack_payload(report_url, tests_failed)
  notify_slack(ENV['SLACK_WEBHOOK_URL'], payload)
end

at_exit do
  report_url = generate_report_and_upload_to_s3
  puts "Report url: #{report_url}" if report_url
  report_to_slack(report_url, tests_failed)
  report_to_pagerduty(report_url, tests_failed)
end
