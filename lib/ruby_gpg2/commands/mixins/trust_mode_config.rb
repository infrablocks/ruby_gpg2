# frozen_string_literal: true

module RubyGPG2
  module Commands
    module Mixins
      module TrustModeConfig
        def configure_command(builder, opts)
          trust_mode = opts[:trust_mode]

          builder = super(builder, opts)
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
