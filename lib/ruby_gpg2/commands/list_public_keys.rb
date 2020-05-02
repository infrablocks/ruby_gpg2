require 'lino'

require_relative 'base'
require_relative 'mixins/global_config'
require_relative 'mixins/colon_config'
require_relative 'mixins/with_captured_output'

module RubyGPG2
  module Commands
    class ListPublicKeys < Base
      include Mixins::GlobalConfig
      include Mixins::ColonConfig
      include Mixins::WithCapturedOutput

      def configure_command(builder, opts)
        builder = builder.with_subcommand('--list-public-keys')
        builder = super(builder, opts)
        builder
      end

      def do_after(opts)
        super(opts.merge(output_method: :public_keys))
      end
    end
  end
end
