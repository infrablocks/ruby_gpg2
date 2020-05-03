module RubyGPG2
  module Commands
    module Mixins
      module ArmorConfig
        def configure_command(builder, opts)
          armor = opts[:armor]

          builder = super(builder, opts)
          builder = builder.with_flag('--armor') if armor
          builder
        end
      end
    end
  end
end
