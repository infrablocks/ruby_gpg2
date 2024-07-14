# frozen_string_literal: true

module RubyGPG2
  module Commands
    module Mixins
      module PassphraseConfig
        private

        def configure_command(builder, parameters)
          passphrase = parameters[:passphrase]

          builder = super(builder, parameters)
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
