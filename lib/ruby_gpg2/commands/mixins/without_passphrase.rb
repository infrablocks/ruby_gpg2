# frozen_string_literal: true

module RubyGPG2
  module Commands
    module Mixins
      module WithoutPassphrase
        def configure_command(builder, opts)
          without_passphrase = opts[:without_passphrase]
          if without_passphrase
            opts = opts.merge(passphrase: '',
                              pinentry_mode: :loopback)
          end
          super(builder, opts)
        end
      end
    end
  end
end
