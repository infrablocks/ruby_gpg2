module RubyGPG2
  module Commands
    module Mixins
      module BatchConfig
        def configure_command(builder, opts)
          batch = opts[:batch].nil? ? true : opts[:batch]

          builder = super(builder, opts)
          builder = builder.with_flag('--batch') if batch
          builder
        end
      end
    end
  end
end
