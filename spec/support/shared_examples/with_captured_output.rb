# frozen_string_literal: true

shared_examples(
  'a command with captured output'
) do |command_name, records, arguments = [], options = {}|
  let(:arguments_string) do
    arguments.empty? ? '' : " #{arguments.join(' ')}"
  end

  let(:command_string) { "#{command_name}#{arguments_string}" }
  let(:binary) { 'path/to/binary' }

  # rubocop:disable RSpec/MultipleExpectations
  it 'parses the output by default' do
    command = described_class.new

    allow(Open4).to(receive(:spawn) do |_, opts|
      opts[:stdout].write(records.join("\n"))
    end)

    result = command.execute(options)

    expect(Open4)
      .to(have_received(:spawn)
        .with(/^#{binary}.* --with-colons .*#{command_string}$/,
              any_args))
    expect(result.output)
      .to(eq(RubyGPG2::ColonOutput.parse(records.join("\n"))))
  end
  # rubocop:enable RSpec/MultipleExpectations

  # rubocop:disable RSpec/MultipleExpectations
  it 'leaves output un-parsed when requested' do
    command = described_class.new

    allow(Open4).to(receive(:spawn) do |_, opts|
      opts[:stdout].write(records.join("\n"))
    end)

    result = command.execute(
      with_colons: true,
      parse_output: false
    )

    expect(Open4)
      .to(have_received(:spawn)
        .with(/^#{binary}.* --with-colons .*#{command_string}$/,
              any_args))
    expect(result.output).to(eq(records.join("\n")))
  end
  # rubocop:enable RSpec/MultipleExpectations
end
