# frozen_string_literal: true

require 'spec_helper'

shared_examples(
  'a command with passphrase config'
) do |command_name, arguments = [], options = {}|
  let(:arguments_string) do
    arguments.empty? ? '' : " #{arguments.join(' ')}"
  end

  let(:command_string) { "#{command_name}#{arguments_string}" }
  let(:binary) { 'path/to/binary' }
  let(:executor) { Lino::Executors::Mock.new }

  before do
    Lino.configure do |config|
      config.executor = executor
    end
  end

  after do
    Lino.reset!
  end

  it 'does not include any passphrase by default' do
    command = described_class.new

    command.execute(options)

    expect(executor.executions.first.command_line.string)
      .to(match(/^#{binary}.* ((?!--passphrase).)*#{command_string}$/))
  end

  it 'passes the specified passphrase when provided' do
    command = described_class.new

    command.execute(
      options.merge(passphrase: 'some-passphrase')
    )

    expect(executor.executions.first.command_line.string)
      .to(match(
            /^#{binary}.* --passphrase "some-passphrase" .*#{command_string}$/
          ))
  end
end
