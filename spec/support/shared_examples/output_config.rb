shared_examples(
    "a command with output config"
) do |command_name, arguments = [], options = {}|
  let(:arguments_string) do
    arguments.empty? ? "" : " #{arguments.join(" ")}"
  end

  let(:command_string) { "#{command_name}#{arguments_string}" }
  let(:binary) { "path/to/binary" }

  it 'does not include any output option by default' do
    command = subject.class.new

    expect(Open4).to(
        receive(:spawn)
            .with(/^#{binary} ((?!--output).)*#{command_string}$/,
                any_args))

    command.execute(options)
  end

  it 'passes the specified output path when provided' do
    command = subject.class.new

    output_file_path = 'some/path/to/output'

    expect(Open4).to(
        receive(:spawn)
            .with(
                /^#{binary}.* --output "#{output_file_path}" .*#{command_string}$/,
                any_args))

    command.execute(
        options.merge(output_file_path: output_file_path))
  end
end
