# frozen_string_literal: true

module RubyGPG2
  module Commands
    module Mixins
      module ArmorConfig
        private

        def configure_command(builder, parameters)
          armor = parameters[:armor]

          builder = super(builder, parameters)
          builder = builder.with_flag('--armor') if armor
          builder
        end
      end
    end
  end
end
