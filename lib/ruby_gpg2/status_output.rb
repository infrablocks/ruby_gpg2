require_relative 'status_line'

module RubyGPG2
  class StatusOutput
    def self.parse(lines)
      new(lines
          .strip
          .split("\n")
          .collect { |line| StatusLine.parse(line) })
    end

    def initialize(lines)
      @lines = lines
    end

    def filter_by_type(type)
      StatusOutput.new(@lines.filter { |l| l.type == type })
    end

    def first_line
      @lines.first
    end

    def ==(other)
      other.class == self.class && other.state == state
    end

    protected

    def state
      [@lines]
    end
  end
end
