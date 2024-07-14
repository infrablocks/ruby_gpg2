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

          builder = super(builder, parameters)
          builder = builder.with_flag('--batch') if batch
          builder
        end
      end
    end
  end
end
