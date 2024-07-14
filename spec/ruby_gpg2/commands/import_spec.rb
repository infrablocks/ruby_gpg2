# frozen_string_literal: true

require 'spec_helper'

describe RubyGPG2::Commands::Import do
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

  it 'calls the gpg --import command' do
    command = described_class.new(binary: 'gpg')

    command.execute

    expect(executor.executions.first.command_line.string)
      .to(match(/^gpg.* --import$/))
  end

  it 'defaults to the configured binary when none provided' do
    command = described_class.new

    command.execute

    expect(executor.executions.first.command_line.string)
      .to(match(%r{^path/to/binary.* --import}))
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

    command.execute(
      key_file_paths: [path1, path2]
    )

    expect(executor.executions.first.command_line.string)
      .to(match(%r{^path/to/binary.* --import #{path1} #{path2}$}))
  end

  it 'passes no key file paths when not provided' do
    command = described_class.new

    command.execute

    expect(executor.executions.first.command_line.string)
      .to(match(%r{^path/to/binary.* --import$}))
  end
end
