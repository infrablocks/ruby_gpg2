# frozen_string_literal: true

require 'spec_helper'

shared_examples(
  'a command with captured output'
) do |command_name, records, arguments = [], options = {}|
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

  # rubocop:disable RSpec/MultipleExpectations
  it 'parses the output by default' do
    command = described_class.new

    executor.write_to_stdout(records.join("\n"))

    result = command.execute(options)

    expect(executor.executions.first.command_line.string)
      .to(match(/^#{binary}.* --with-colons .*#{command_string}$/))
    expect(result.output)
      .to(eq(RubyGPG2::ColonOutput.parse(records.join("\n"))))
  end
  # rubocop:enable RSpec/MultipleExpectations

  # rubocop:disable RSpec/MultipleExpectations
  it 'leaves output un-parsed when requested' do
    command = described_class.new

    executor.write_to_stdout(records.join("\n"))

    result = command.execute(
      with_colons: true,
      parse_output: false
    )

    expect(executor.executions.first.command_line.string)
      .to(match(/^#{binary}.* --with-colons .*#{command_string}$/))
    expect(result.output).to(eq(records.join("\n")))
  end
  # rubocop:enable RSpec/MultipleExpectations
end
