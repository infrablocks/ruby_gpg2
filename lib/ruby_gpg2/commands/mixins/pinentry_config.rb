# frozen_string_literal: true

module RubyGPG2
  module Commands
    module Mixins
      module PinentryConfig
        def configure_command(builder, opts)
          pinentry_mode = opts[:pinentry_mode]

          builder = super(builder, opts)
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
