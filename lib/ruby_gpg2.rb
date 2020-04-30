require 'ruby_gpg2/version'
require 'ruby_gpg2/commands'
require 'ruby_gpg2/parameter_file'
require 'ruby_gpg2/colon_output'

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
    attr_accessor :binary, :logger, :stdin, :stdout, :stderr

    def initialize
      @binary = 'gpg'
      @stdin = ''
      @stdout = $stdout
      @stderr = $stderr
    end
  end
end
