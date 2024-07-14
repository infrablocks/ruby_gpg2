# frozen_string_literal: true

module RubyGPG2
  module Commands
    module Mixins
      module TrustModeConfig
        private

        def configure_command(builder, parameters)
          trust_mode = parameters[:trust_mode]

          b = super
          if trust_mode
            b = b.with_option(
              '--trust-mode', trust_mode
            )
          end
          b
        end
      end
    end
  end
end
