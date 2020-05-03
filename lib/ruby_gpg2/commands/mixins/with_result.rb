require 'stringio'

module RubyGPG2
  module Commands
    module Mixins
      module WithResult
        def do_after(opts)
          result = super(opts)
          result.output = opts[:output] if opts[:output]
          result.status = opts[:status] if opts[:status]
          result
        end
      end
    end
  end
end
