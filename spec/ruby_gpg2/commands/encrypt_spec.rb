# frozen_string_literal: true

require 'spec_helper'

describe RubyGPG2::Commands::Encrypt do
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

  it 'calls the gpg --encrypt command' do
    command = described_class.new(binary: 'gpg')

    command.execute

    expect(executor.executions.first.command_line.string)
      .to(match(/^gpg.* --encrypt/))
  end

  it 'defaults to the configured binary when none provided' do
    command = described_class.new

    command.execute

    expect(executor.executions.first.command_line.string)
      .to(match(%r{^path/to/binary.* --encrypt}))
  end

  it_behaves_like('a command with global config', '--encrypt')
  it_behaves_like('a command with batch config', '--encrypt')
  it_behaves_like('a command with armor config', '--encrypt')
  it_behaves_like('a command with input config', '--encrypt')
  it_behaves_like('a command with output config', '--encrypt')
  it_behaves_like('a command with recipient config', '--encrypt')
  it_behaves_like('a command with trust mode config', '--encrypt')
end
