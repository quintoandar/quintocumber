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


## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

Install development external dependencies:

* Allure CLI 2.2.1 (https://github.com/allure-framework/allure2/releases/tag/2.2.1)
* Firefox and geckodriver

To install this gem onto your local machine, run `bundle exec rake install`. 

To run all tests: `bin/test`

To release a new version run `gem bump --version (major|minor|patch)`, which will create a git tag and commit for the version. Push the new commit and tag with `git push`.

Push the `.gem` file to [rubygems.org](https://rubygems.org) using `gem push quintocumber-<NEW_VERSION_TAG>.gem`

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/quintoandar/quintocumber.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
