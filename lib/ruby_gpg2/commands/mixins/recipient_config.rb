# frozen_string_literal: true

module RubyGPG2
  module Commands
    module Mixins
      module RecipientConfig
        def configure_command(builder, opts)
          recipient = opts[:recipient]

          builder = super(builder, opts)
          if recipient
            builder = builder.with_option(
              '--recipient', recipient
            )
          end
          builder
        end
      end
    end
  end
end
