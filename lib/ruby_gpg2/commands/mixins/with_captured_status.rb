# frozen_string_literal: true

require 'tempfile'

require_relative '../../status_output'

module RubyGPG2
  module Commands
    module Mixins
      module WithCapturedStatus
        private

        # rubocop:disable Metrics/MethodLength
        def do_around(parameters, invocation_options)
          if parameters[:with_status]
            Tempfile.create('status-file', parameters[:work_directory]) do |f|
              result = yield(
                parameters.merge(status_file: f.path), invocation_options
              )
              @status = File.read(f.path)
              result
            end
          else
            yield parameters, invocation_options
          end
        end
        # rubocop:enable Metrics/MethodLength

        def status(parameters)
          parameters[:parse_status] ? StatusOutput.parse(@status) : @status
        end

        def parameter_defaults(parameters)
          parse_status = parameters[:parse_status]
          super.merge(parse_status: parse_status.nil? ? true : parse_status)
        end

        def process_result(result, parameters, invocation_options)
          result = super(result, parameters, invocation_options)
          result.status = status(parameters) if parameters[:with_status]
          result
        end
      end
    end
  end
end
