# frozen_string_literal: true

shared_examples(
  'a command with input config'
) do |command_name, arguments = [], options = {}|
  let(:arguments_string) do
    arguments.empty? ? '' : " #{arguments.join(' ')}"
  end

  let(:command_string) { "#{command_name}#{arguments_string}" }
  let(:binary) { 'path/to/binary' }

  it 'passes the specified input path as an argument when provided' do
    command = described_class.new

    input_file_path = 'some/path/to/input'

    allow(Open4).to(receive(:spawn))

    command.execute(
      options.merge(input_file_path: input_file_path)
    )

    expect(Open4)
      .to(have_received(:spawn)
            .with(
              /^#{binary}.* #{command_string} #{input_file_path}$/,
              any_args
            ))
  end
end
