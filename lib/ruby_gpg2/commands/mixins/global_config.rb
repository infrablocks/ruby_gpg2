module RubyGPG2
  module Commands
    module Mixins
      module GlobalConfig
        def configure_command(builder, opts)
          batch = opts[:batch].nil? ? true : opts[:batch]
          home_directory = opts[:home_directory]

          builder = super(builder, opts)
          builder = builder.with_flag('--batch') if batch
          builder = builder.with_option(
              '--homedir', home_directory, quoting: '"') if home_directory
          builder
        end
      end
    end
  end
end
