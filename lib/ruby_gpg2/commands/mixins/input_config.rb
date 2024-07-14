# frozen_string_literal: true

module RubyGPG2
  module Commands
    module Mixins
      module InputConfig
        private

        def configure_command(builder, parameters)
          input_file_path = parameters[:input_file_path]

          builder = super(builder, parameters)
          builder = builder.with_argument(input_file_path) if input_file_path
          builder
        end
      end
    end
  end
end
