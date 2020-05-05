module RubyGPG2
  module Commands
    module Mixins
      module RecipientConfig
        def configure_command(builder, opts)
          recipient = opts[:recipient]

          builder = super(builder, opts)
          builder = builder.with_option(
                '--recipient', recipient) if recipient
          builder
        end
      end
    end
  end
end
