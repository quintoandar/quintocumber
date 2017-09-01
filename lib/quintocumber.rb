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

        # TODO: Extract and improve this block
        retry_attempts = 0
        retry_attempts_idx = args.index("--retry")
        if retry_attempts_idx
            args.slice(retry_attempts_idx)
            retry_attempts = args.slice(retry_attempts_idx + 1)
            puts retry_attempts
        end

        begin 
          Cucumber::Cli::Main.new(args, nil, @out, @err, @kernel).execute!
        rescue SystemExit
          i = 0
          while i < retry_attempts.to_i
            # TODO: Extract and improve this block
            puts "Retry ##{i+1}"
            args_to_retry = args.clone
            args_to_retry + File.readlines("failed.txt")
            begin
              Cucumber::Cli::Main.new(args_to_retry, nil, @out, @err, @kernel).execute!
            rescue SystemExit
              i = i + 1
            end
          end
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
