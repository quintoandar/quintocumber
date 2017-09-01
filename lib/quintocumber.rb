# frozen_string_literal: true

require 'quintocumber/version'
require 'cucumber/cli/main'

module Quintocumber
  module Cli
    # CLI entrypoint class
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
        args = default_args(loader_file) + @args
        args.push("--format", "rerun", "--out", "failed.txt")
        exit_code = begin
          Cucumber::Cli::Main.new(args, nil, @out, @err, @kernel).execute!
        ensure
          puts "BLALAAAAAA"
          # Cucumber::Cli::Main.new(args, nil, @out, @err, @kernel).execute!
          puts exit_code
        end
      end

      def default_args(loader_file)
        [
          '--format',
          'pretty',
          '--format',
          'AllureCucumber::Formatter',
          '--out',
          'reports',
          '--require',
          loader_file.to_s
        ]
      end
    end
  end
end
