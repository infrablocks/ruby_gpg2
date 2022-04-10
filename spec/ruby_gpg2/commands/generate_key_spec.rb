# frozen_string_literal: true

require 'spec_helper'

describe RubyGPG2::Commands::GenerateKey do
  before do
    RubyGPG2.configure do |config|
      config.binary = 'path/to/binary'
    end
  end

  after do
    RubyGPG2.reset!
  end

  it 'calls the gpg --generate-key command' do
    command = described_class.new(binary: 'gpg')

    allow(Open4).to(receive(:spawn))

    command.execute

    expect(Open4)
      .to(have_received(:spawn)
            .with(/^gpg.* --generate-key$/, any_args))
  end

  it 'defaults to the configured binary when none provided' do
    command = described_class.new

    allow(Open4).to(receive(:spawn))

    command.execute

    expect(Open4)
      .to(have_received(:spawn)
            .with(%r{^path/to/binary.* --generate-key$}, any_args))
  end

  it_behaves_like('a command with global config', '--generate-key')
  it_behaves_like('a command with batch config', '--generate-key')
  it_behaves_like('a command with passphrase config', '--generate-key')
  it_behaves_like('a command with pinentry config', '--generate-key')
  it_behaves_like('a command with status config', '--generate-key')
  it_behaves_like('a command allowing no passphrase', '--generate-key')
  it_behaves_like(
    'a command with captured status',
    '--generate-key',
    [
      '[GNUPG:] KEY_CONSIDERED 84870BD38FF91666D90E1711B9AC18BF92CE18F3 0',
      '[GNUPG:] KEY_CREATED B 84870BD38FF91666D90E1711B9AC18BF92CE18F3'
    ]
  )

  it 'passes the parameter file as an argument when supplied' do
    parameter_file_path = 'some/parameter/file'

    command = described_class.new

    allow(Open4).to(receive(:spawn))

    command.execute(
      parameter_file_path: parameter_file_path
    )

    expect(Open4)
      .to(have_received(:spawn)
            .with(%r{^path/to/binary.* --generate-key #{parameter_file_path}$},
                  any_args))
  end
end
