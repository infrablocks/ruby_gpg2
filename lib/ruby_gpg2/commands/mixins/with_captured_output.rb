# frozen_string_literal: true

require 'stringio'

module RubyGPG2
  module Commands
    module Mixins
      module WithCapturedOutput
        private

        def parameter_defaults(parameters)
          parse_output = parameters[:parse_output]
          super.merge(parse_output: parse_output.nil? ? true : parse_output)
        end

        def invocation_option_defaults(_invocation_options)
          super.merge(capture: [:stdout])
        end

        def process_result(result, parameters, invocation_options)
          r = super
          if parameters[:parse_output]
            r.output =
              ColonOutput.parse(r.output)
          end
          r
        end
      end
    end
  end
end
