require 'spec_helper'

require_relative '../../support/shared_examples/global_config'

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
            .with(/^path\/to\/binary.* --generate-key/, any_args))

    command.execute
  end

  it_behaves_like "a command with global config", '--generate-key'

  it 'passes the parameter file as an argument when supplied' do
    parameter_file_path = 'some/parameter/file'

    command = subject.class.new

    expect(Open4).to(
        receive(:spawn)
            .with(/^path\/to\/binary.* --generate-key #{parameter_file_path}/,
                any_args))

    command.execute(
        parameter_file_path: parameter_file_path)
  end
end
