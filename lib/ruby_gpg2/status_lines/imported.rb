# frozen_string_literal: true

module RubyGPG2
  module StatusLines
    class Imported
      def self.parse(line)
        match = line.match(/^\[GNUPG:\] IMPORTED (.*?) (.*)$/)
        new(
          raw: line,
          key_id: match[1],
          user_id: match[2]
        )
      end

      attr_reader(
        :raw,
        :key_id,
        :user_id
      )

      def initialize(opts)
        @raw = opts[:raw]
        @key_id = opts[:key_id]
        @user_id = opts[:user_id]
      end

      def type
        :imported
      end

      def ==(other)
        other.class == self.class && other.state == state
      end

      protected

      def state
        [
          @raw,
          @key_id,
          @user_id
        ]
      end
    end
  end
end
