require 'spec_helper'

require_relative '../../support/shared_examples/global_config'
require_relative '../../support/shared_examples/batch_config'
require_relative '../../support/shared_examples/armor_config'
require_relative '../../support/shared_examples/input_config'
require_relative '../../support/shared_examples/output_config'
require_relative '../../support/shared_examples/recipient_config'
require_relative '../../support/shared_examples/trust_mode_config'

describe RubyGPG2::Commands::Encrypt do
  before(:each) do
    RubyGPG2.configure do |config|
      config.binary = 'path/to/binary'
    end
  end

  after(:each) do
    RubyGPG2.reset!
  end

  it 'calls the gpg --encrypt command' do
    command = subject.class.new(binary: 'gpg')

    expect(Open4).to(
        receive(:spawn)
            .with(/^gpg.* --encrypt/, any_args))

    command.execute
  end

  it 'defaults to the configured binary when none provided' do
    command = subject.class.new

    expect(Open4).to(
        receive(:spawn)
            .with(/^path\/to\/binary.* --encrypt/, any_args))

    command.execute
  end

  it_behaves_like "a command with global config", '--encrypt'
  it_behaves_like "a command with batch config", '--encrypt'
  it_behaves_like "a command with armor config", '--encrypt'
  it_behaves_like "a command with input config", '--encrypt'
  it_behaves_like "a command with output config", '--encrypt'
  it_behaves_like "a command with recipient config", '--encrypt'
  it_behaves_like "a command with trust mode config", '--encrypt'
end
