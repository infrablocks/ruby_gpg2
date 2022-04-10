# frozen_string_literal: true

require 'spec_helper'

describe RubyGPG2::Commands::Decrypt do
  before do
    RubyGPG2.configure do |config|
      config.binary = 'path/to/binary'
    end
  end

  after do
    RubyGPG2.reset!
  end

  it 'calls the gpg --decrypt command' do
    command = described_class.new(binary: 'gpg')

    allow(Open4).to(receive(:spawn))

    command.execute

    expect(Open4)
      .to(have_received(:spawn)
            .with(/^gpg.* --decrypt/, any_args))
  end

  it 'defaults to the configured binary when none provided' do
    command = described_class.new

    allow(Open4).to(receive(:spawn))

    command.execute

    expect(Open4)
      .to(have_received(:spawn)
            .with(%r{^path/to/binary.* --decrypt}, any_args))
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
