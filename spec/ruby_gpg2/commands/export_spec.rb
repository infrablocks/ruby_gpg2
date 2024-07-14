# frozen_string_literal: true

require 'spec_helper'

describe RubyGPG2::Commands::Export do
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

  it 'calls the gpg --export command' do
    command = described_class.new(binary: 'gpg')

    command.execute

    expect(executor.executions.first.command_line.string)
      .to(match(/^gpg.* --export$/))
  end

  it 'defaults to the configured binary when none provided' do
    command = described_class.new

    command.execute

    expect(executor.executions.first.command_line.string)
      .to(match(%r{^path/to/binary.* --export}))
  end

  it_behaves_like('a command with global config', '--export')
  it_behaves_like('a command with armor config', '--export')
  it_behaves_like('a command with output config', '--export')

  it 'passes all names when provided' do
    command = described_class.new

    name1 = 'jen@example.com'
    name2 = 'john@example.com'

    command.execute(names: [name1, name2])

    expect(executor.executions.first.command_line.string)
      .to(match(%r{^path/to/binary.* --export #{name1} #{name2}$}))
  end

  it 'passes no names when not provided' do
    command = described_class.new

    command.execute

    expect(executor.executions.first.command_line.string)
      .to(match(%r{^path/to/binary.* --export$}))
  end
end
