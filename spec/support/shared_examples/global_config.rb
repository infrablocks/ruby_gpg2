# frozen_string_literal: true

require 'spec_helper'

shared_examples(
  'a command with global config'
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

  it 'does not set a home directory by default' do
    command = subject.class.new

    command.execute(options)

    expect(executor.executions.first.command_line.string)
      .to(match(/^#{binary} ((?!--homedir).)*#{command_string}$/))
  end

  it 'includes the provided home directory' do
    home_directory = './gpg'

    command = subject.class.new

    command.execute(
      options.merge(home_directory:)
    )

    expect(executor.executions.first.command_line.string)
      .to(match(
            /^#{binary}.* --homedir "#{home_directory}" .*#{command_string}$/
          ))
  end

  it 'includes the no-tty flag by default' do
    command = subject.class.new

    command.execute(options)

    expect(executor.executions.first.command_line.string)
      .to(match(/^#{binary}.* --no-tty .*#{command_string}$/))
  end

  it 'includes the no-tty flag when without tty is true' do
    command = subject.class.new

    command.execute(
      options.merge(without_tty: true)
    )

    expect(executor.executions.first.command_line.string)
      .to(match(/^#{binary}.* --no-tty .*#{command_string}$/))
  end

  it 'does not include the no-tty flag when without tty is false' do
    command = subject.class.new

    command.execute(
      options.merge(without_tty: false)
    )

    expect(executor.executions.first.command_line.string)
      .to(match(/^#{binary} ((?!--no-tty).)*#{command_string}$/))
  end
end
