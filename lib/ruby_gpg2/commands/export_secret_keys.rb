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

      def configure_command(builder, opts)
        names = opts[:names] || []

        builder = super(builder, opts)
        builder = builder.with_subcommand('--export-secret-keys')
        names.each do |name|
          builder = builder.with_argument(name)
        end
        builder
      end
    end
  end
end
