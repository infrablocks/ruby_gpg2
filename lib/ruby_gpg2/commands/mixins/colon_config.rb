# frozen_string_literal: true

module RubyGPG2
  module Commands
    module Mixins
      module ColonConfig
        private

        def parameter_defaults(parameters)
          with_colons = parameters[:with_colons]
          super.merge(with_colons: with_colons.nil? ? true : with_colons)
        end

        def configure_command(builder, parameters)
          with_colons = parameters[:with_colons]

          builder = super(builder, parameters)
          builder = builder.with_flag('--with-colons') if with_colons
          builder
        end
      end
    end
  end
end
