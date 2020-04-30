module RubyGPG2
  module Commands
    module Mixins
      module ColonConfig
        def configure_command(builder, opts)
          with_colons = opts[:with_colons].nil? ? true : opts[:with_colons]

          builder = super(builder, opts)
          builder = builder.with_flag('--with-colons') if with_colons
          builder
        end
      end
    end
  end
end
