module RubyGPG2
  module Commands
    module Mixins
      module PassphraseConfig
        def configure_command(builder, opts)
          passphrase = opts[:passphrase]

          builder = super(builder, opts)
          builder = builder.with_option(
                '--passphrase', passphrase, quoting: "'") if passphrase
          builder
        end
      end
    end
  end
end
