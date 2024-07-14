# frozen_string_literal: true

module RubyGPG2
  module Commands
    module Mixins
      module WithoutPassphrase
        def configure_command(builder, parameters)
          without_passphrase = parameters[:without_passphrase]
          p = parameters
          if without_passphrase
            p = p.merge(
              passphrase: '',
              pinentry_mode: :loopback
            )
          end
          super(builder, p)
        end
      end
    end
  end
end
