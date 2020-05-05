module RubyGPG2
  module StatusLines
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
  end
end