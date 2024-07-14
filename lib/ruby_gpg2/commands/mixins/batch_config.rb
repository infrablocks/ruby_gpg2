# frozen_string_literal: true

module RubyGPG2
  module Commands
    module Mixins
      module BatchConfig
        private

        def parameter_defaults(parameters)
          batch = parameters[:batch]
          super.merge(batch: batch.nil? ? true : batch)
        end

        def configure_command(builder, parameters)
          batch = parameters[:batch]

          b = super
          b = b.with_flag('--batch') if batch
          b
        end
      end
    end
  end
end
