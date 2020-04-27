require 'ruby_gpg2/version'
require 'ruby_gpg2/commands'
require 'ruby_gpg2/parameter_file'

module RubyGPG2
  class << self
    attr_writer :configuration

    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield(configuration)
    end

    def reset!
      @configuration = nil
    end
  end

  class Configuration
    attr_accessor :binary

    def initialize
      @binary = 'gpg'
    end
  end
end
