# frozen_string_literal: true

require 'spec_helper'

describe RubyGPG2::Commands::Encrypt do
  before do
    RubyGPG2.configure do |config|
      config.binary = 'path/to/binary'
    end
  end

  after do
    RubyGPG2.reset!
  end

  it 'calls the gpg --encrypt command' do
    command = described_class.new(binary: 'gpg')

    allow(Open4).to(receive(:spawn))

    command.execute

    expect(Open4)
      .to(have_received(:spawn)
            .with(/^gpg.* --encrypt/, any_args))
  end

  it 'defaults to the configured binary when none provided' do
    command = described_class.new

    allow(Open4).to(receive(:spawn))

    command.execute

    expect(Open4)
      .to(have_received(:spawn)
            .with(%r{^path/to/binary.* --encrypt}, any_args))
  end

  it_behaves_like('a command with global config', '--encrypt')
  it_behaves_like('a command with batch config', '--encrypt')
  it_behaves_like('a command with armor config', '--encrypt')
  it_behaves_like('a command with input config', '--encrypt')
  it_behaves_like('a command with output config', '--encrypt')
  it_behaves_like('a command with recipient config', '--encrypt')
  it_behaves_like('a command with trust mode config', '--encrypt')
end
