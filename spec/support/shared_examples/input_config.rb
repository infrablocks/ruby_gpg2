shared_examples(
    "a command with input config"
) do |command_name, arguments = [], options = {}|
  let(:arguments_string) do
    arguments.empty? ? "" : " #{arguments.join(" ")}"
  end

  let(:command_string) { "#{command_name}#{arguments_string}" }
  let(:binary) { "path/to/binary" }

  it 'passes the specified input path as an argument when provided' do
    command = subject.class.new

    input_file_path = 'some/path/to/input'

    expect(Open4).to(
        receive(:spawn)
            .with(
                /^#{binary}.* #{command_string} #{input_file_path}$/,
                any_args))

    command.execute(
        options.merge(input_file_path: input_file_path))
  end
end
