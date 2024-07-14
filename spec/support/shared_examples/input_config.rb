# frozen_string_literal: true

require 'spec_helper'

shared_examples(
  'a command with input config'
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

  it 'passes the specified input path as an argument when provided' do
    command = described_class.new

    input_file_path = 'some/path/to/input'

    command.execute(
      options.merge(input_file_path:)
    )

    expect(executor.executions.first.command_line.string)
      .to(match(/^#{binary}.* #{command_string} #{input_file_path}$/))
  end
end
