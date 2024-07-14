# frozen_string_literal: true

require 'lino'

require_relative 'base'
require_relative 'mixins/global_config'
require_relative 'mixins/batch_config'
require_relative 'mixins/passphrase_config'
require_relative 'mixins/pinentry_config'
require_relative 'mixins/armor_config'
require_relative 'mixins/output_config'
require_relative 'mixins/without_passphrase'

module RubyGPG2
  module Commands
    class ExportSecretKeys < Base
      include Mixins::GlobalConfig
      include Mixins::BatchConfig
      include Mixins::PassphraseConfig
      include Mixins::PinentryConfig
      include Mixins::ArmorConfig
      include Mixins::OutputConfig
      include Mixins::WithoutPassphrase

      def configure_command(builder, parameters)
        names = parameters[:names] || []

        b = super
        b = b.with_subcommand('--export-secret-keys')
        names.each do |name|
          b = b.with_argument(name)
        end
        b
      end
    end
  end
end
