# frozen_string_literal: true

module RubyGPG2
  module Commands
    module Mixins
      module ArmorConfig
        private

        def configure_command(builder, parameters)
          armor = parameters[:armor]

          b = super
          b = b.with_flag('--armor') if armor
          b
        end
      end
    end
  end
end
