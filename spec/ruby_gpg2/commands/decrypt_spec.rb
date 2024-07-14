# frozen_string_literal: true

require 'spec_helper'

describe RubyGPG2::Commands::Decrypt do
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

  it 'calls the gpg --decrypt command' do
    command = described_class.new(binary: 'gpg')

    command.execute

    expect(executor.executions.first.command_line.string)
      .to(match(/^gpg.* --decrypt/))
  end

  it 'defaults to the configured binary when none provided' do
    command = described_class.new

    command.execute

    expect(executor.executions.first.command_line.string)
      .to(match(%r{^path/to/binary.* --decrypt}))
  end

  it_behaves_like('a command with global config', '--decrypt')
  it_behaves_like('a command with batch config', '--decrypt')
  it_behaves_like('a command with input config', '--decrypt')
  it_behaves_like('a command with output config', '--decrypt')
  it_behaves_like('a command with trust mode config', '--decrypt')
  it_behaves_like('a command with passphrase config', '--decrypt')
  it_behaves_like('a command with pinentry config', '--decrypt')
  it_behaves_like('a command allowing no passphrase', '--decrypt')
end
