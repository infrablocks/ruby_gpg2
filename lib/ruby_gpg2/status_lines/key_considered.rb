module RubyGPG2
  module StatusLines
    class KeyConsidered
      FLAGS = {
          '0' => [],
          '1' => [:key_not_selected],
          '2' => [:all_subkeys_expired_or_revoked]
      }

      def self.parse(line)
        match = line.match(/^\[GNUPG:\] KEY_CONSIDERED (.*) (.*)$/)
        new(
            raw: line,
            key_fingerprint: match[1],
            flags: FLAGS[match[2]])
      end

      attr_reader(
          :raw,
          :key_fingerprint,
          :flags)

      def initialize(opts)
        @raw = opts[:raw]
        @key_fingerprint = opts[:key_fingerprint]
        @flags = opts[:flags]
      end

      def type
        :key_considered
      end

      def ==(other)
        other.class == self.class && other.state == state
      end

      protected

      def state
        [
            @raw,
            @key_fingerprint,
            @flags
        ]
      end
    end
  end
end