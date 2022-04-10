# frozen_string_literal: true

module RubyGPG2
  module Commands
    module Mixins
      module StatusConfig
        def configure_command(builder, opts)
          status_file = opts[:status_file]

          builder = super(builder, opts)
          if status_file
            builder = builder.with_option(
              '--status-file', status_file, quoting: '"'
            )
          end
          builder
        end
      end
    end
  end
end
