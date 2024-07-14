# frozen_string_literal: true

module RubyGPG2
  module Commands
    module Mixins
      module RecipientConfig
        private

        def configure_command(builder, parameters)
          recipient = parameters[:recipient]

          builder = super(builder, parameters)
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
