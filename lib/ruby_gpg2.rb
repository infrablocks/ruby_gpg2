# frozen_string_literal: true

require 'ruby_gpg2/version'
require 'ruby_gpg2/commands'
require 'ruby_gpg2/parameter_file_contents'
require 'ruby_gpg2/colon_output'
require 'ruby_gpg2/status_output'
require 'ruby_gpg2/status_lines'
require 'ruby_gpg2/key'
require 'ruby_gpg2/user_id'

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

  module ClassMethods
    def decrypt(opts = {})
      Commands::Decrypt.new.execute(opts)
    end

    def encrypt(opts = {})
      Commands::Encrypt.new.execute(opts)
    end

    def export(opts = {})
      Commands::Export.new.execute(opts)
    end

    def export_secret_keys(opts = {})
      Commands::ExportSecretKeys.new.execute(opts)
    end

    def generate_key(opts = {})
      Commands::GenerateKey.new.execute(opts)
    end

    def import(opts = {})
      Commands::Import.new.execute(opts)
    end

    def list_public_keys(opts = {})
      Commands::ListPublicKeys.new.execute(opts)
    end

    def list_secret_keys(opts = {})
      Commands::ListSecretKeys.new.execute(opts)
    end
  end

  extend ClassMethods

  def self.included(other)
    other.extend(ClassMethods)
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
