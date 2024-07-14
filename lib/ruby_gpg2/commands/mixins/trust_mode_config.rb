# frozen_string_literal: true

module RubyGPG2
  module Commands
    module Mixins
      module TrustModeConfig
        private

        def configure_command(builder, parameters)
          trust_mode = parameters[:trust_mode]

          builder = super(builder, parameters)
          if trust_mode
            builder = builder.with_option(
              '--trust-mode', trust_mode
            )
          end
          builder
        end
      end
    end
  end
end
