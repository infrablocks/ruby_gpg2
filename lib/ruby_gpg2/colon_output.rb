require_relative './colon_record'

module RubyGPG2
  class ColonOutput
    def self.parse(records)
      new(records
          .strip
          .split("\n")
          .collect { |record| ColonRecord.parse(record) })
    end

    include Enumerable

    def initialize(records)
      @records = records
    end

    def each(&block)
      @records.each(&block)
    end

    def ==(other)
      other.class == self.class && other.state == state
    end

    protected

    def state
      [@records]
    end
  end
end