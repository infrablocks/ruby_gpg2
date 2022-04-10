# frozen_string_literal: true

require 'spec_helper'

describe RubyGPG2::Commands::Import do
  before do
    RubyGPG2.configure do |config|
      config.binary = 'path/to/binary'
    end
  end

  after do
    RubyGPG2.reset!
  end

  it 'calls the gpg --import command' do
    command = described_class.new(binary: 'gpg')

    allow(Open4).to(receive(:spawn))

    command.execute

    expect(Open4)
      .to(have_received(:spawn)
            .with(/^gpg.* --import$/, any_args))
  end

  it 'defaults to the configured binary when none provided' do
    command = described_class.new

    allow(Open4).to(receive(:spawn))

    command.execute

    expect(Open4)
      .to(have_received(:spawn)
            .with(%r{^path/to/binary.* --import}, any_args))
  end

  it_behaves_like('a command with global config', '--import')
  it_behaves_like('a command with batch config', '--import')
  it_behaves_like('a command with status config', '--import')
  it_behaves_like(
    'a command with captured status', '--import',
    [
      '[GNUPG:] KEY_CONSIDERED A65C6366D55F0BA7719EE38F582D74F22F5601F9 0',
      '[GNUPG:] IMPORTED 582D74F22F5601F8 Joe Fox <jfox@example.com>',
      '[GNUPG:] IMPORT_OK 1 A65C6366D55F0BA7719EE38F582D74F22F5601F9',
      '[GNUPG:] IMPORT_RES 1 0 1 0 0 0 0 0 0 0 0 0 0 0 0'
    ]
  )

  it 'passes all key files paths when provided' do
    command = described_class.new

    path1 = 'some/directory/key1.gpgpkey'
    path2 = 'some/directory/key2.gpgpkey'

    allow(Open4).to(receive(:spawn))

    command.execute(
      key_file_paths: [path1, path2]
    )

    expect(Open4)
      .to(have_received(:spawn)
            .with(
              %r{^path/to/binary.* --import #{path1} #{path2}$},
              any_args
            ))
  end

  it 'passes no key file paths when not provided' do
    command = described_class.new

    allow(Open4).to(receive(:spawn))

    command.execute

    expect(Open4)
      .to(have_received(:spawn)
            .with(
              %r{^path/to/binary.* --import$},
              any_args
            ))
  end
end
