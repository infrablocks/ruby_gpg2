# frozen_string_literal: true

require 'lino'

require_relative 'base'
require_relative 'mixins/global_config'
require_relative 'mixins/batch_config'
require_relative 'mixins/status_config'
require_relative 'mixins/with_captured_status'

module RubyGPG2
  module Commands
    class Import < Base
      include Mixins::GlobalConfig
      include Mixins::BatchConfig
      include Mixins::StatusConfig
      include Mixins::WithCapturedStatus

      def configure_command(builder, parameters)
        key_file_paths = parameters[:key_file_paths] || []

        b = super
        b = b.with_subcommand('--import')
        key_file_paths.each do |key_file_path|
          b = b.with_argument(key_file_path)
        end
        b
      end
    end
  end
end
