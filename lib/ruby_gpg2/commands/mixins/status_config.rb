module RubyGPG2
  module Commands
    module Mixins
      module StatusConfig
        def configure_command(builder, opts)
          status_file = opts[:status_file]

          builder = super(builder, opts)
          builder = builder.with_option(
              '--status-file', status_file, quoting: '"') if status_file
          builder
        end
      end
    end
  end
end
