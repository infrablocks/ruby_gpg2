require 'spec_helper'

require_relative '../../support/shared_examples/global_config'
require_relative '../../support/shared_examples/batch_config'
require_relative '../../support/shared_examples/passphrase_config'
require_relative '../../support/shared_examples/pinentry_config'
require_relative '../../support/shared_examples/armor_config'
require_relative '../../support/shared_examples/output_config'
require_relative '../../support/shared_examples/without_passphrase'

describe RubyGPG2::Commands::ExportSecretKeys do
  before(:each) do
    RubyGPG2.configure do |config|
      config.binary = 'path/to/binary'
    end
  end

  after(:each) do
    RubyGPG2.reset!
  end

  it 'calls the gpg --export-secret-keys command' do
    command = subject.class.new(binary: 'gpg')

    expect(Open4).to(
        receive(:spawn)
            .with(/^gpg.* --export-secret-keys/, any_args))

    command.execute
  end

  it 'defaults to the configured binary when none provided' do
    command = subject.class.new

    expect(Open4).to(
        receive(:spawn)
            .with(/^path\/to\/binary.* --export-secret-keys/, any_args))

    command.execute
  end

  it_behaves_like "a command with global config", '--export-secret-keys'
  it_behaves_like "a command with batch config", '--export-secret-keys'
  it_behaves_like "a command with passphrase config", '--export-secret-keys'
  it_behaves_like "a command with pinentry config", '--export-secret-keys'
  it_behaves_like "a command with armor config", '--export-secret-keys'
  it_behaves_like "a command with output config", '--export-secret-keys'
  it_behaves_like "a command allowing no passphrase", '--export-secret-keys'

  it 'passes all names when provided' do
    command = subject.class.new

    name_1 = 'jen@example.com'
    name_2 = 'john@example.com'

    expect(Open4).to(
        receive(:spawn)
            .with(
                /^path\/to\/binary.* --export-secret-keys #{name_1} #{name_2}$/,
                any_args))

    command.execute(names: [name_1, name_2])
  end

  it 'passes no names when not provided' do
    command = subject.class.new

    expect(Open4).to(
        receive(:spawn)
            .with(
                /^path\/to\/binary.* --export-secret-keys$/,
                any_args))

    command.execute
  end
end
