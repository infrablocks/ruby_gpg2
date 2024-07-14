# frozen_string_literal: true

module RubyGPG2
  module Commands
    module Mixins
      module PinentryConfig
        private

        def configure_command(builder, parameters)
          pinentry_mode = parameters[:pinentry_mode]

          builder = super(builder, parameters)
          if pinentry_mode
            builder = builder.with_option(
              '--pinentry-mode', pinentry_mode
            )
          end
          builder
        end
      end
    end
  end
end
