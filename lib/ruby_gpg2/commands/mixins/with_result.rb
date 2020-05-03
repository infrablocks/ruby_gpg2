require 'stringio'

module RubyGPG2
  module Commands
    module Mixins
      module WithResult
        class Result < Struct.new(:output, :status)
        end

        def do_after(opts)
          result = Result.new
          result.output = opts[:output] if opts[:output]
          result.status = opts[:status] if opts[:status]
          result
        end
      end
    end
  end
end
