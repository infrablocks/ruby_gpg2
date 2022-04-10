# frozen_string_literal: true

module RubyGPG2
  module Commands
    module Mixins
      module OutputConfig
        def configure_command(builder, opts)
          output_file_path = opts[:output_file_path]

          builder = super(builder, opts)
          if output_file_path
            builder = builder.with_option(
              '--output', output_file_path, quoting: '"'
            )
          end
          builder
        end
      end
    end
  end
end
