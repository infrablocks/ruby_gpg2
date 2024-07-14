# frozen_string_literal: true

module RubyGPG2
  module Commands
    module Mixins
      module StatusConfig
        private

        def configure_command(builder, parameters)
          status_file = parameters[:status_file]

          builder = super(builder, parameters)
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
