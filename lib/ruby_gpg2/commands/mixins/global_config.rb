# frozen_string_literal: true

module RubyGPG2
  module Commands
    module Mixins
      module GlobalConfig
        private

        def parameter_defaults(parameters)
          without_tty = parameters[:without_tty]
          super.merge(without_tty: without_tty.nil? ? true : without_tty)
        end

        def configure_command(builder, parameters)
          home_directory = parameters[:home_directory]
          without_tty = parameters[:without_tty]

          builder = super(builder, parameters)
          if home_directory
            builder = builder.with_option(
              '--homedir', home_directory, quoting: '"'
            )
          end
          builder = builder.with_flag('--no-tty') if without_tty
          builder
        end
      end
    end
  end
end
