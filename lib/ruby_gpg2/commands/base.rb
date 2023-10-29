# frozen_string_literal: true

require 'lino'

require_relative 'result'

module RubyGPG2
  module Commands
    class Base
      def initialize(binary: nil, stdin: nil, stdout: nil, stderr: nil)
        @binary = binary || RubyGPG2.configuration.binary
        @stdin = stdin || RubyGPG2.configuration.stdin
        @stdout = stdout || RubyGPG2.configuration.stdout
        @stderr = stderr || RubyGPG2.configuration.stderr
      end

      def execute(opts = {})
        do_before(opts)
        do_around(opts) do |updated_opts|
          builder = configure_command(instantiate_builder, updated_opts)
          builder
            .build
            .execute(stdin: stdin, stdout: stdout, stderr: stderr)
        end
        do_after(opts)
      end

      protected

      attr_reader :binary, :stdin, :stdout, :stderr

      def instantiate_builder
        Lino::CommandLineBuilder
          .for_command(binary)
      end

      def do_before(_); end

      def configure_command(builder, _opts)
        builder
      end

      def do_around(opts)
        yield opts
      end

      def do_after(_)
        Result.new
      end
    end
  end
end
