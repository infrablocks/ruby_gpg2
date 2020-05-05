require 'lino'

require_relative 'base'
require_relative 'mixins/global_config'
require_relative 'mixins/batch_config'
require_relative 'mixins/armor_config'
require_relative 'mixins/input_config'
require_relative 'mixins/output_config'
require_relative 'mixins/recipient_config'

module RubyGPG2
  module Commands
    class Encrypt < Base
      include Mixins::GlobalConfig
      include Mixins::BatchConfig
      include Mixins::ArmorConfig
      include Mixins::InputConfig
      include Mixins::OutputConfig
      include Mixins::RecipientConfig

      def configure_command(builder, opts)
        builder = super(builder, opts)
        builder = builder.with_subcommand('--encrypt')
        builder
      end
    end
  end
end
