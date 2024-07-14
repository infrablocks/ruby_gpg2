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

        b = super
        b = b.with_subcommand('--export')
        names.each do |name|
          b = b.with_argument(name)
        end
        b
      end
    end
  end
end
