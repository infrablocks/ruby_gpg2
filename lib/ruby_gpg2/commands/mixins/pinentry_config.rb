# frozen_string_literal: true

module RubyGPG2
  module Commands
    module Mixins
      module PinentryConfig
        private

        def configure_command(builder, parameters)
          pinentry_mode = parameters[:pinentry_mode]

          b = super
          if pinentry_mode
            b = b.with_option(
              '--pinentry-mode', pinentry_mode
            )
          end
          b
        end
      end
    end
  end
end
