require 'lino'

require_relative 'base'
require_relative 'mixins/global_config'
require_relative 'mixins/batch_config'
require_relative 'mixins/status_config'
require_relative 'mixins/with_result'
require_relative 'mixins/with_captured_status'

module RubyGPG2
  module Commands
    class Import < Base
      include Mixins::GlobalConfig
      include Mixins::BatchConfig
      include Mixins::StatusConfig
      include Mixins::WithResult
      include Mixins::WithCapturedStatus

      def configure_command(builder, opts)
        key_file_paths = opts[:key_file_paths] || []

        builder = super(builder, opts)
        builder = builder.with_subcommand('--import')
        key_file_paths.each do |key_file_path|
          builder = builder.with_argument(key_file_path)
        end
        builder
      end
    end
  end
end
