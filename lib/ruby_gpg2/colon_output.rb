require_relative './colon_record'

module RubyGPG2
  class ColonOutput
    def self.parse(records)
      new(records
          .strip
          .split("\n")
          .collect { |record| KeyListRecord.parse(record) })
    end

    include Enumerable

    def initialize(records)
      @records = records
    end

    def each(&block)
      @records.each(&block)
    end
  end
end