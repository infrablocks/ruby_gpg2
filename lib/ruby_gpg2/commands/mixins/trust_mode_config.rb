module RubyGPG2
  module Commands
    module Mixins
      module TrustModeConfig
        def configure_command(builder, opts)
          trust_mode = opts[:trust_mode]

          builder = super(builder, opts)
          builder = builder.with_option(
                '--trust-mode', trust_mode) if trust_mode
          builder
        end
      end
    end
  end
end
