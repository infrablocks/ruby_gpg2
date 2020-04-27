require 'lino'

require_relative 'base'
require_relative 'mixins/global_config'

module RubyGPG2
  module Commands
    class GenerateKey < Base
      include Mixins::GlobalConfig

      def configure_command(builder, opts)
        parameter_file_path = opts[:parameter_file_path]

        builder = builder.with_subcommand('--generate-key')
        builder = super(builder, opts)
        builder = builder.with_argument(parameter_file_path) if parameter_file_path
        builder
      end
    end
  end
end
