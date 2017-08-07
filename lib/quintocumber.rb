# frozen_string_literal: true

require 'quintocumber/version'
require 'cucumber/cli/main'

module Quintocumber
  module Cli
    class Main
      def initialize(args, _ = nil, out = STDOUT, err = STDERR, kernel = Kernel)
        @args   = args
        @out    = out
        @err    = err
        @kernel = kernel
      end

      def execute!
        if ENV['TESTS']
          require 'setup_tests/coverage'
          require 'setup_tests/mocks'
        end
        loader_file = File.join(File.dirname(__FILE__), '/loader.rb')
        cmd_args = @args.join(' ')
        args = "--format pretty --format AllureCucumber::Formatter --out reports --require #{loader_file} #{cmd_args}".split(/\s+/)
        result = Cucumber::Cli::Main.new(args, nil, @out, @err, @kernel).execute!
      end
    end
  end
end
