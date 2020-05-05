module RubyGPG2
  module Commands
    module Mixins
      module InputConfig
        def configure_command(builder, opts)
          input_file_path = opts[:input_file_path]

          builder = super(builder, opts)
          builder = builder.with_argument(input_file_path) if input_file_path
          builder
        end
      end
    end
  end
end
