# frozen_string_literal: true

require 'spec_helper'

describe RubyGPG2::Commands::Export do
  before do
    RubyGPG2.configure do |config|
      config.binary = 'path/to/binary'
    end
  end

  after do
    RubyGPG2.reset!
  end

  it 'calls the gpg --export command' do
    command = described_class.new(binary: 'gpg')

    allow(Open4).to(receive(:spawn))

    command.execute

    expect(Open4)
      .to(have_received(:spawn)
            .with(/^gpg.* --export$/, any_args))
  end

  it 'defaults to the configured binary when none provided' do
    command = described_class.new

    allow(Open4).to(receive(:spawn))

    command.execute

    expect(Open4)
      .to(have_received(:spawn)
            .with(%r{^path/to/binary.* --export}, any_args))
  end

  it_behaves_like('a command with global config', '--export')
  it_behaves_like('a command with armor config', '--export')
  it_behaves_like('a command with output config', '--export')

  it 'passes all names when provided' do
    command = described_class.new

    name1 = 'jen@example.com'
    name2 = 'john@example.com'

    allow(Open4).to(receive(:spawn))

    command.execute(names: [name1, name2])

    expect(Open4)
      .to(have_received(:spawn)
            .with(
              %r{^path/to/binary.* --export #{name1} #{name2}$},
              any_args
            ))
  end

  it 'passes no names when not provided' do
    command = described_class.new

    allow(Open4).to(receive(:spawn))

    command.execute

    expect(Open4)
      .to(have_received(:spawn)
            .with(
              %r{^path/to/binary.* --export$},
              any_args
            ))
  end
end
