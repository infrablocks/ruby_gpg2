shared_examples(
    "a command with status config"
) do |command_name, arguments = [], options = {}|
  let(:arguments_string) do
    arguments.empty? ? "" : " #{arguments.join(" ")}"
  end

  let(:command_string) { "#{command_name}#{arguments_string}" }
  let(:binary) { "path/to/binary" }

  it 'does not include the status file option by default' do
    command = subject.class.new

    expect(Open4).to(
        receive(:spawn)
            .with(/^#{binary}.* ((?!--status-file).)*#{command_string}$/,
                any_args))

    command.execute(options)
  end

  it 'includes the specified status file when provided' do
    command = subject.class.new

    expect(Open4).to(
        receive(:spawn)
            .with(/^#{binary}.* --status-file="some\/status\/file" .*#{command_string}$/,
                any_args))

    command.execute(
        options.merge(status_file: 'some/status/file'))
  end
end
