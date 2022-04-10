# frozen_string_literal: true

require 'lino'

require_relative 'base'
require_relative 'mixins/global_config'
require_relative 'mixins/batch_config'
require_relative 'mixins/input_config'
require_relative 'mixins/output_config'
require_relative 'mixins/trust_mode_config'
require_relative 'mixins/passphrase_config'
require_relative 'mixins/pinentry_config'
require_relative 'mixins/without_passphrase'

module RubyGPG2
  module Commands
    class Decrypt < Base
      include Mixins::GlobalConfig
      include Mixins::BatchConfig
      include Mixins::InputConfig
      include Mixins::OutputConfig
      include Mixins::TrustModeConfig
      include Mixins::PassphraseConfig
      include Mixins::PinentryConfig
      include Mixins::WithoutPassphrase

      def configure_command(builder, opts)
        builder = super(builder, opts)
        builder.with_subcommand('--decrypt')
      end
    end
  end
end
