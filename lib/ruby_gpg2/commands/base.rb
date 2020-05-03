require 'lino'

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
        builder = instantiate_builder

        do_before(opts)
        do_around(opts) do |updated_opts|
          builder = configure_command(builder, updated_opts)
          builder
              .build
              .execute(
                  stdin: stdin,
                  stdout: stdout,
                  stderr: stderr)
        end
        do_after(opts)
      end

      protected

      attr_reader :binary, :stdin, :stdout, :stderr

      def instantiate_builder
        Lino::CommandLineBuilder
            .for_command(binary)
            .with_option_separator('=')
      end

      def do_before(opts)
      end

      def configure_command(builder, opts)
        builder
      end

      def do_around(opts)
        yield opts
      end

      def do_after(opts)
      end
    end
  end
end
