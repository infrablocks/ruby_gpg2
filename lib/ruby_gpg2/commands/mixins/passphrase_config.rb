module RubyGPG2
  module Commands
    module Mixins
      module PassphraseConfig
        def configure_command(builder, opts)
          without_passphrase = opts[:without_passphrase].nil? ?
              false :
              opts[:without_passphrase]
          passphrase = opts[:passphrase]

          builder = super(builder, opts)
          if passphrase
            builder = builder.with_option(
                '--passphrase', passphrase, quoting: "'")
          elsif without_passphrase
            builder = builder.with_option(
                '--passphrase', '', quoting: "'")
          end
          builder
        end
      end
    end
  end
end
