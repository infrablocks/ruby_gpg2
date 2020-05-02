require 'spec_helper'

require_relative '../../support/shared_examples/global_config'
require_relative '../../support/shared_examples/colon_config'

describe RubyGPG2::Commands::ListSecretKeys do
  before(:each) do
    RubyGPG2.configure do |config|
      config.binary = 'path/to/binary'
    end
  end

  after(:each) do
    RubyGPG2.reset!
  end

  it 'calls the gpg --list-secret-keys command' do
    command = subject.class.new(binary: 'gpg')

    expect(Open4).to(
        receive(:spawn)
            .with(/^gpg.* --list-secret-keys$/, any_args))

    command.execute
  end

  it 'defaults to the configured binary when none provided' do
    command = subject.class.new

    expect(Open4).to(
        receive(:spawn)
            .with(/^path\/to\/binary.* --list-secret-keys/, any_args))

    command.execute
  end

  it_behaves_like "a command with global config", '--list-secret-keys'
  it_behaves_like "a command with colon config", '--list-secret-keys',
      [
          'sec:u:2048:1:1A16916844CE9D82:1333003000:::u:::scESC:::+:::23::0:',
          'fpr:::::::::41D2606F66C3FF28874362B61A16916844CE9D82:'
      ],
      :secret_keys
end
