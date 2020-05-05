module RubyGPG2
  module StatusLines
    class KeyCreated
      KEY_TYPES = {
          'B' => :primary_and_subkey,
          'P' => :primary,
          'S' => :subkey
      }

      def self.parse(line)
        match = line.match(/^\[GNUPG:\] KEY_CREATED (.) (.*?)(?: (.*))?$/)
        new(
            raw: line,
            key_type: KEY_TYPES[match[1]],
            key_fingerprint: match[2],
            handle: match[3])
      end

      attr_reader(
          :raw,
          :key_type,
          :key_fingerprint,
          :handle)

      def initialize(opts)
        @raw = opts[:raw]
        @key_type = opts[:key_type]
        @key_fingerprint = opts[:key_fingerprint]
        @handle = opts[:handle]
      end

      def type
        :key_created
      end

      def ==(other)
        other.class == self.class && other.state == state
      end

      protected

      def state
        [
            @raw,
            @key_type,
            @key_fingerprint
        ]
      end
    end
  end
end