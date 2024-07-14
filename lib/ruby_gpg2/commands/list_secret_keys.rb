# frozen_string_literal: true

require 'lino'

require_relative 'base'
require_relative 'mixins/global_config'
require_relative 'mixins/colon_config'
require_relative 'mixins/with_captured_output'

module RubyGPG2
  module Commands
    class ListSecretKeys < Base
      include Mixins::GlobalConfig
      include Mixins::ColonConfig
      include Mixins::WithCapturedOutput

      def configure_command(builder, parameters)
        builder = builder.with_subcommand('--list-secret-keys')
        super(builder, parameters)
      end
    end
  end
end
