# frozen_string_literal: true

require 'lino'

require_relative 'base'
require_relative 'mixins/global_config'
require_relative 'mixins/batch_config'
require_relative 'mixins/passphrase_config'
require_relative 'mixins/pinentry_config'
require_relative 'mixins/status_config'
require_relative 'mixins/with_captured_status'
require_relative 'mixins/without_passphrase'

module RubyGPG2
  module Commands
    class GenerateKey < Base
      include Mixins::GlobalConfig
      include Mixins::BatchConfig
      include Mixins::PassphraseConfig
      include Mixins::PinentryConfig
      include Mixins::StatusConfig
      include Mixins::WithCapturedStatus
      include Mixins::WithoutPassphrase

      def configure_command(builder, parameters)
        parameter_file_path = parameters[:parameter_file_path]

        b = builder.with_subcommand('--generate-key')
        b = super(b, parameters)
        b = b.with_argument(parameter_file_path) if parameter_file_path
        b
      end
    end
  end
end
