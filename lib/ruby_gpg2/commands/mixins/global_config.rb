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

          b = super
          if home_directory
            b = b.with_option(
              '--homedir', home_directory, quoting: '"'
            )
          end
          b = b.with_flag('--no-tty') if without_tty
          b
        end
      end
    end
  end
end
