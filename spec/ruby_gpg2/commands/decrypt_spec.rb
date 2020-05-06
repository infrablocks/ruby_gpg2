require 'spec_helper'

require_relative '../../support/shared_examples/global_config'
require_relative '../../support/shared_examples/batch_config'
require_relative '../../support/shared_examples/input_config'
require_relative '../../support/shared_examples/output_config'
require_relative '../../support/shared_examples/trust_mode_config'
require_relative '../../support/shared_examples/passphrase_config'
require_relative '../../support/shared_examples/pinentry_config'
require_relative '../../support/shared_examples/without_passphrase'

describe RubyGPG2::Commands::Decrypt do
  before(:each) do
    RubyGPG2.configure do |config|
      config.binary = 'path/to/binary'
    end
  end

  after(:each) do
    RubyGPG2.reset!
  end

  it 'calls the gpg --decrypt command' do
    command = subject.class.new(binary: 'gpg')

    expect(Open4).to(
        receive(:spawn)
            .with(/^gpg.* --decrypt/, any_args))

    command.execute
  end

  it 'defaults to the configured binary when none provided' do
    command = subject.class.new

    expect(Open4).to(
        receive(:spawn)
            .with(/^path\/to\/binary.* --decrypt/, any_args))

    command.execute
  end

  it_behaves_like "a command with global config", '--decrypt'
  it_behaves_like "a command with batch config", '--decrypt'
  it_behaves_like "a command with input config", '--decrypt'
  it_behaves_like "a command with output config", '--decrypt'
  it_behaves_like "a command with trust mode config", '--decrypt'
  it_behaves_like "a command with passphrase config", '--decrypt'
  it_behaves_like "a command with pinentry config", '--decrypt'
  it_behaves_like "a command allowing no passphrase", '--decrypt'
end
