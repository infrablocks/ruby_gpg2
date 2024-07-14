# frozen_string_literal: true

module RubyGPG2
  module Commands
    module Mixins
      module PassphraseConfig
        private

        def configure_command(builder, parameters)
          passphrase = parameters[:passphrase]

          b = super
          if passphrase
            b = b.with_option(
              '--passphrase', passphrase, quoting: '"'
            )
          end
          b
        end
      end
    end
  end
end
