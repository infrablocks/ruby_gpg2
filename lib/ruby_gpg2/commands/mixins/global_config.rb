module RubyGPG2
  module Commands
    module Mixins
      module GlobalConfig
        def configure_command(builder, opts)
          home_directory = opts[:home_directory]
          without_tty = opts[:without_tty].nil? ? true : opts[:without_tty]

          builder = super(builder, opts)
          builder = builder.with_option(
              '--homedir', home_directory, quoting: '"') if home_directory
          builder = builder.with_flag('--no-tty') if without_tty
          builder
        end
      end
    end
  end
end
