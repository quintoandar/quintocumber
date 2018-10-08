# Quintocumber

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'quintocumber'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install quintocumber

## Usage

    $ quintocumber

The following environment variables allow you to you to configure the appllication behavior:

| Key  | Description |
| ------------- | ------------- |
| BROWSERSTACK_USERNAME | username for Browserstack account  |
| BROWSERSTACK_ACCESS_KEY | access key for Browserstack account |
| BROWSERSTACK_LOCAL | uses local Browserstack if set to `true` |
| SLACK_WEBHOOK_URL | webhook for slack notifications |
| REPORT_BUCKET | s3 bucket to save allure reports |
| PAGERDUTY_ROUTING_KEY | pager duty Events Api v2 integration key |

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

Install development external dependencies:

* Allure CLI 2.2.1 (https://github.com/allure-framework/allure2/releases/tag/2.2.1)
* Firefox and geckodriver

To install this gem onto your local machine, run `bundle exec rake install`.

To run all tests: `bin/test`

To release a new version run `bump patch`, which will create a git tag and commit for the version. Push the new commit and tag with `git push`.

To generate a new gem, now run `gem build quintocumber.gemspec`.

Push the `.gem` file to [rubygems.org](https://rubygems.org) using `gem push quintocumber-<NEW_VERSION_TAG>.gem`

## Using Browserstack locally
You may want to run tests on Browserstack against a local version or on a protected envirionment. ([More use cases](https://www.browserstack.com/local-testing#configuration))
You'll need:
1. Set env vars `BROWSERSTACK_LOCAL=true` and `BROWSERSTACK_USERNAME`, `BROWSERSTACK_ACCESS_KEY`
2. Have the [local binary running](https://www.browserstack.com/local-testing#command-line)

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/quintoandar/quintocumber.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
