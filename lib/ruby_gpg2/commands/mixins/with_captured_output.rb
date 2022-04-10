# frozen_string_literal: true

require 'stringio'

module RubyGPG2
  module Commands
    module Mixins
      module WithCapturedOutput
        def initialize(*args)
          super(*args)
          @stdout = StringIO.new unless
              defined?(@stdout) && @stdout.respond_to?(:string)
        end

        def do_after(opts)
          super(opts.merge(output: resolve_output(stdout.string, opts)))
        end

        private

        def resolve_output(output, opts)
          parse_output = opts[:parse_output].nil? ? true : opts[:parse_output]
          parse_output ? ColonOutput.parse(output) : output
        end
      end
    end
  end
end
