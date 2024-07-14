# frozen_string_literal: true

module RubyGPG2
  module Commands
    module Mixins
      module RecipientConfig
        private

        def configure_command(builder, parameters)
          recipient = parameters[:recipient]

          b = super
          if recipient
            b = b.with_option(
              '--recipient', recipient
            )
          end
          b
        end
      end
    end
  end
end
