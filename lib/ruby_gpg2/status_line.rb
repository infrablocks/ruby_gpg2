module RubyGPG2
  class StatusLine
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

    class Unimplemented
      def self.parse(line)
        new(raw: line)
      end

      attr_reader(
          :raw)

      def initialize(opts)
        @raw = opts[:raw]
      end

      def type
        :unknown
      end

      def ==(other)
        other.class == self.class && other.state == state
      end

      protected

      def state
        [
            @raw
        ]
      end
    end

    TYPE_REGEX = /^\[GNUPG:\] (.*?)(\s|$)/

    TYPES = {
        "KEY_CREATED" => KeyCreated,
        "KEY_CONSIDERED" => KeyConsidered
    }

    def self.parse(line)
      TYPES
          .fetch(
              line.match(TYPE_REGEX)[1],
              Unimplemented)
          .parse(line)
    end
  end
end