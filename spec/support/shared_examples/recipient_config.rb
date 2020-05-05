shared_examples(
    "a command with recipient config"
) do |command_name, arguments = [], options = {}|
  let(:arguments_string) do
    arguments.empty? ? "" : " #{arguments.join(" ")}"
  end

  let(:command_string) { "#{command_name}#{arguments_string}" }
  let(:binary) { "path/to/binary" }

  it 'does not include any recipient option by default' do
    command = subject.class.new

    expect(Open4).to(
        receive(:spawn)
            .with(/^#{binary} ((?!--recipient).)*#{command_string}$/,
                any_args))

    command.execute(options)
  end

  it 'passes the specified recipient when provided' do
    command = subject.class.new

    recipient = 'jules@example.com'

    expect(Open4).to(
        receive(:spawn)
            .with(
                /^#{binary}.* --recipient #{recipient} .*#{command_string}$/,
                any_args))

    command.execute(
        options.merge(recipient: recipient))
  end
end
