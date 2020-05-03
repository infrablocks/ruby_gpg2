require 'spec_helper'

require_relative '../../support/shared_examples/global_config'
require_relative '../../support/shared_examples/batch_config'
require_relative '../../support/shared_examples/passphrase_config'
require_relative '../../support/shared_examples/pinentry_config'
require_relative '../../support/shared_examples/status_config'
require_relative '../../support/shared_examples/with_captured_status'
require_relative '../../support/shared_examples/without_passphrase'

describe RubyGPG2::Commands::GenerateKey do
  before(:each) do
    RubyGPG2.configure do |config|
      config.binary = 'path/to/binary'
    end
  end

  after(:each) do
    RubyGPG2.reset!
  end

  it 'calls the gpg --generate-key command' do
    command = subject.class.new(binary: 'gpg')

    expect(Open4).to(
        receive(:spawn)
            .with(/^gpg.* --generate-key$/, any_args))

    command.execute
  end

  it 'defaults to the configured binary when none provided' do
    command = subject.class.new

    expect(Open4).to(
        receive(:spawn)
            .with(/^path\/to\/binary.* --generate-key$/, any_args))

    command.execute
  end

  it_behaves_like "a command with global config", '--generate-key'
  it_behaves_like "a command with batch config", '--generate-key'
  it_behaves_like "a command with passphrase config", '--generate-key'
  it_behaves_like "a command with pinentry config", '--generate-key'
  it_behaves_like "a command with status config", '--generate-key'
  it_behaves_like "a command allowing no passphrase", '--generate-key'
  it_behaves_like "a command with captured status", '--generate-key',
      [
          '[GNUPG:] KEY_CONSIDERED 84870BD38FF91666D90E1711B9AC18BF92CE18F3 0',
          '[GNUPG:] KEY_CREATED B 84870BD38FF91666D90E1711B9AC18BF92CE18F3'
      ]

  it 'passes the parameter file as an argument when supplied' do
    parameter_file_path = 'some/parameter/file'

    command = subject.class.new

    expect(Open4).to(
        receive(:spawn)
            .with(/^path\/to\/binary.* --generate-key #{parameter_file_path}$/,
                any_args))

    command.execute(
        parameter_file_path: parameter_file_path)
  end
end
