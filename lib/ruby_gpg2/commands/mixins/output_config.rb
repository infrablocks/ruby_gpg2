# frozen_string_literal: true

module RubyGPG2
  module Commands
    module Mixins
      module OutputConfig
        private

        def configure_command(builder, parameters)
          output_file_path = parameters[:output_file_path]

          b = super
          if output_file_path
            b = b.with_option(
              '--output', output_file_path, quoting: '"'
            )
          end
          b
        end
      end
    end
  end
end
