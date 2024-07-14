# frozen_string_literal: true

require 'spec_helper'

shared_examples(
  'a command with pinentry config'
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

  it 'does not include any pinentry mode by default' do
    command = described_class.new

    command.execute(options)

    expect(executor.executions.first.command_line.string)
      .to(match(/^#{binary}.* ((?!--pinentry-mode).)*#{command_string}$/))
  end

  it 'uses the specified pinentry mode when provided' do
    command = described_class.new

    command.execute(
      options.merge(pinentry_mode: :loopback)
    )

    expect(executor.executions.first.command_line.string)
      .to(match(/^#{binary}.* --pinentry-mode loopback .*#{command_string}$/))
  end
end
