# frozen_string_literal: true

module RubyGPG2
  module Commands
    module Mixins
      module WithoutPassphrase
        def configure_command(builder, parameters)
          without_passphrase = parameters[:without_passphrase]
          if without_passphrase
            parameters = parameters.merge(passphrase: '',
                                          pinentry_mode: :loopback)
          end
          super(builder, parameters)
        end
      end
    end
  end
end
