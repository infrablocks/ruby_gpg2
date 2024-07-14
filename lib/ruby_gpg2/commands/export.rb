# frozen_string_literal: true

require 'lino'

require_relative 'base'
require_relative 'mixins/global_config'
require_relative 'mixins/armor_config'
require_relative 'mixins/output_config'

module RubyGPG2
  module Commands
    class Export < Base
      include Mixins::GlobalConfig
      include Mixins::ArmorConfig
      include Mixins::OutputConfig

      def configure_command(builder, parameters)
        names = parameters[:names] || []

        builder = super(builder, parameters)
        builder = builder.with_subcommand('--export')
        names.each do |name|
          builder = builder.with_argument(name)
        end
        builder
      end
    end
  end
end
