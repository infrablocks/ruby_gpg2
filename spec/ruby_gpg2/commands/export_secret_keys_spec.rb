# frozen_string_literal: true

require 'spec_helper'

describe RubyGPG2::Commands::ExportSecretKeys do
  let(:executor) { Lino::Executors::Mock.new }

  before do
    Lino.configure do |config|
      config.executor = executor
    end
    RubyGPG2.configure do |config|
      config.binary = 'path/to/binary'
    end
  end

  after do
    RubyGPG2.reset!
    Lino.reset!
  end

  it 'calls the gpg --export-secret-keys command' do
    command = described_class.new(binary: 'gpg')

    command.execute

    expect(executor.executions.first.command_line.string)
      .to(match(/^gpg.* --export-secret-keys/))
  end

  it 'defaults to the configured binary when none provided' do
    command = described_class.new

    command.execute

    expect(executor.executions.first.command_line.string)
      .to(match(%r{^path/to/binary.* --export-secret-keys}))
  end

  it_behaves_like('a command with global config', '--export-secret-keys')
  it_behaves_like('a command with batch config', '--export-secret-keys')
  it_behaves_like('a command with passphrase config', '--export-secret-keys')
  it_behaves_like('a command with pinentry config', '--export-secret-keys')
  it_behaves_like('a command with armor config', '--export-secret-keys')
  it_behaves_like('a command with output config', '--export-secret-keys')
  it_behaves_like('a command allowing no passphrase', '--export-secret-keys')

  it 'passes all names when provided' do
    command = described_class.new

    name1 = 'jen@example.com'
    name2 = 'john@example.com'

    command.execute(names: [name1, name2])

    expect(executor.executions.first.command_line.string)
      .to(match(%r{^path/to/binary.* --export-secret-keys #{name1} #{name2}$}))
  end

  it 'passes no names when not provided' do
    command = described_class.new

    command.execute

    expect(executor.executions.first.command_line.string)
      .to(match(%r{^path/to/binary.* --export-secret-keys$}))
  end
end
