require 'spec_helper'

require_relative '../../support/shared_examples/global_config'
require_relative '../../support/shared_examples/batch_config'
require_relative '../../support/shared_examples/status_config'
require_relative '../../support/shared_examples/with_captured_status'

describe RubyGPG2::Commands::Import do
  before(:each) do
    RubyGPG2.configure do |config|
      config.binary = 'path/to/binary'
    end
  end

  after(:each) do
    RubyGPG2.reset!
  end

  it 'calls the gpg --import command' do
    command = subject.class.new(binary: 'gpg')

    expect(Open4).to(
        receive(:spawn)
            .with(/^gpg.* --import$/, any_args))

    command.execute
  end

  it 'defaults to the configured binary when none provided' do
    command = subject.class.new

    expect(Open4).to(
        receive(:spawn)
            .with(/^path\/to\/binary.* --import/, any_args))

    command.execute
  end

  it_behaves_like "a command with global config", '--import'
  it_behaves_like "a command with batch config", '--import'
  it_behaves_like "a command with status config", '--import'
  it_behaves_like "a command with captured status", '--import',
      [
          '[GNUPG:] KEY_CONSIDERED A65C6366D55F0BA7719EE38F582D74F22F5601F9 0',
          '[GNUPG:] IMPORTED 582D74F22F5601F8 Joe Fox <jfox@example.com>',
          '[GNUPG:] IMPORT_OK 1 A65C6366D55F0BA7719EE38F582D74F22F5601F9',
          '[GNUPG:] IMPORT_RES 1 0 1 0 0 0 0 0 0 0 0 0 0 0 0'
      ]

  it 'passes all key files paths when provided' do
    command = subject.class.new

    path_1 = 'some/directory/key1.gpgpkey'
    path_2 = 'some/directory/key2.gpgpkey'

    expect(Open4).to(
        receive(:spawn)
            .with(
                /^path\/to\/binary.* --import #{path_1} #{path_2}$/,
                any_args))

    command.execute(
        key_file_paths: [path_1, path_2])
  end

  it 'passes no key file paths when not provided' do
    command = subject.class.new

    expect(Open4).to(
        receive(:spawn)
            .with(
                /^path\/to\/binary.* --import$/,
                any_args))

    command.execute
  end
end
