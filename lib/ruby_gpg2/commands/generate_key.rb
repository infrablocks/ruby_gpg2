require 'lino'

require_relative 'base'
require_relative 'mixins/global_config'

module RubyGPG2
  module Commands
    class GenerateKey < Base
      include Mixins::GlobalConfig

      def configure_command(builder, opts)
        parameter_file = opts[:parameter_file]

        builder = builder.with_subcommand('--generate-key')
        builder = super(builder, opts)
        builder = builder.with_argument(parameter_file) if parameter_file
        builder
      end
    end
  end
end
