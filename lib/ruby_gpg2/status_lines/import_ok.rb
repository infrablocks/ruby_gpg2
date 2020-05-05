module RubyGPG2
  module StatusLines
    class ImportOK
      REASONS = {
          1 => :new_key,
          2 => :new_user_ids,
          4 => :new_signatures,
          8 => :new_subkeys,
          16 => :private_key
      }

      def self.parse(line)
        match = line.match(/^\[GNUPG:\] IMPORT_OK (\d+) (.*)$/)
        new(
            raw: line,
            reasons: reasons(match[1]),
            key_fingerprint: match[2])
      end

      attr_reader(
          :raw,
          :reasons,
          :key_fingerprint)

      def initialize(opts)
        @raw = opts[:raw]
        @reasons = opts[:reasons]
        @key_fingerprint = opts[:key_fingerprint]
      end

      def type
        :import_ok
      end

      def ==(other)
        other.class == self.class && other.state == state
      end

      protected

      def state
        [
            @raw,
            @reasons,
            @key_fingerprint
        ]
      end

      private

      def self.reasons(value)
        value = value.to_i
        if value == 0
          [:no_change]
        else
          REASONS.inject([]) do |r, entry|
            (value & entry[0]) > 0 ?
                (r << entry[1]) :
                r
          end
        end
      end
    end
  end
end
