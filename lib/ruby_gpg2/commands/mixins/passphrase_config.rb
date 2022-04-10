# frozen_string_literal: true

module RubyGPG2
  module Commands
    module Mixins
      module PassphraseConfig
        def configure_command(builder, opts)
          passphrase = opts[:passphrase]

          builder = super(builder, opts)
          if passphrase
            builder = builder.with_option(
              '--passphrase', passphrase, quoting: '"'
            )
          end
          builder
        end
      end
    end
  end
end
