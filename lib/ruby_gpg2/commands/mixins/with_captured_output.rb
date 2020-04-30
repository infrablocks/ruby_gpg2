require 'stringio'

module RubyGPG2
  module Commands
    module Mixins
      module WithCapturedOutput
        def initialize(*args)
          super(*args)
          @stdout = StringIO.new unless
              (defined?(@stdout) && @stdout.respond_to?(:string))
        end

        def do_after(opts)
          parse_output = opts[:parse_output].nil? ? true : opts[:parse_output]
          parse_output ?
              ColonOutput.parse(stdout.string) :
              stdout.string
        end
      end
    end
  end
end
