module RubyGPG2
  module Commands
    module Mixins
      module WithoutPassphrase
        def configure_command(builder, opts)
          without_passphrase = opts[:without_passphrase]
          super(builder, without_passphrase ?
              opts.merge(passphrase: '', pinentry_mode: :loopback) :
              opts)
        end
      end
    end
  end
end
