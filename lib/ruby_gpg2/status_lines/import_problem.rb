# frozen_string_literal: true

module RubyGPG2
  module StatusLines
    class ImportProblem
      REASONS = {
        0 => :no_reason_given,
        1 => :invalid_certificate,
        2 => :issuer_certificate_missing,
        3 => :certificate_chain_too_long,
        4 => :error_storing_certificate
      }.freeze

      def self.parse(line)
        match = line.match(/^\[GNUPG:\] IMPORT_PROBLEM (\d+) (.*)$/)
        new(
          raw: line,
          reason: REASONS[match[1].to_i],
          key_fingerprint: match[2]
        )
      end

      attr_reader(
        :raw,
        :reason,
        :key_fingerprint
      )

      def initialize(opts)
        @raw = opts[:raw]
        @reason = opts[:reason]
        @key_fingerprint = opts[:key_fingerprint]
      end

      def type
        :import_problem
      end

      def ==(other)
        other.class == self.class && other.state == state
      end

      protected

      def state
        [
          @raw,
          @reason,
          @key_fingerprint
        ]
      end
    end
  end
end
