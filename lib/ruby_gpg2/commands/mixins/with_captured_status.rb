# frozen_string_literal: true

require 'tempfile'

require_relative '../../status_output'

module RubyGPG2
  module Commands
    module Mixins
      module WithCapturedStatus
        def do_around(opts)
          if opts[:with_status]
            Tempfile.create('status-file', opts[:work_directory]) do |f|
              yield opts.merge(status_file: f.path)
              @status = File.read(f.path)
            end
          else
            yield opts
          end
        end

        def do_after(opts)
          if opts[:with_status]
            super(opts.merge(status: resolve_status(@status, opts)))
          else
            super(opts)
          end
        end

        private

        def resolve_status(status, opts)
          parse_status = opts[:parse_status].nil? ? true : opts[:parse_status]
          parse_status ? StatusOutput.parse(status) : status
        end
      end
    end
  end
end
