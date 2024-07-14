# frozen_string_literal: true

module RubyGPG2
  module Commands
    module Mixins
      module StatusConfig
        private

        def configure_command(builder, parameters)
          status_file = parameters[:status_file]

          b = super
          if status_file
            b = b.with_option(
              '--status-file', status_file, quoting: '"'
            )
          end
          b
        end
      end
    end
  end
end
