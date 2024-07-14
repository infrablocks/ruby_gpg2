# frozen_string_literal: true

require 'spec_helper'

describe RubyGPG2::Commands::GenerateKey do
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

  it 'calls the gpg --generate-key command' do
    command = described_class.new(binary: 'gpg')

    command.execute

    expect(executor.executions.first.command_line.string)
      .to(match(/^gpg.* --generate-key$/))
  end

  it 'defaults to the configured binary when none provided' do
    command = described_class.new

    command.execute

    expect(executor.executions.first.command_line.string)
      .to(match(%r{^path/to/binary.* --generate-key$}))
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

    command.execute(
      parameter_file_path:
    )

    expect(executor.executions.first.command_line.string)
      .to(match(%r{^path/to/binary.* --generate-key #{parameter_file_path}$}))
  end
end
