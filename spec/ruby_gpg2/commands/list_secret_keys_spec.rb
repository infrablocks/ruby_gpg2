# frozen_string_literal: true

require 'spec_helper'

describe RubyGPG2::Commands::ListSecretKeys do
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

  it 'calls the gpg --list-secret-keys command' do
    command = described_class.new(binary: 'gpg')

    command.execute

    expect(executor.executions.first.command_line.string)
      .to(match(/^gpg.* --list-secret-keys$/))
  end

  it 'defaults to the configured binary when none provided' do
    command = described_class.new

    command.execute

    expect(executor.executions.first.command_line.string)
      .to(match(%r{^path/to/binary.* --list-secret-keys}))
  end

  it_behaves_like('a command with global config', '--list-secret-keys')
  it_behaves_like('a command with colon config', '--list-secret-keys')
  it_behaves_like(
    'a command with captured output', '--list-secret-keys',
    %w[sec:u:2048:1:1A16916844CE9D82:1333003000:::u:::scESC:::+:::23::0:
       fpr:::::::::41D2606F66C3FF28874362B61A16916844CE9D82:]
  )
end
