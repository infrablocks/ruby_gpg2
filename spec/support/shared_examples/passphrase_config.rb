shared_examples(
    "a command with passphrase config"
) do |command_name, arguments = [], options = {}|
  let(:arguments_string) do
    arguments.empty? ? "" : " #{arguments.join(" ")}"
  end

  let(:command_string) { "#{command_name}#{arguments_string}" }
  let(:binary) { "path/to/binary" }

  it 'does not include any passphrase by default' do
    command = subject.class.new

    expect(Open4).to(
        receive(:spawn)
            .with(/^#{binary}.* ((?!--passphrase).)*#{command_string}$/,
                any_args))

    command.execute(options)
  end

  it 'passes the specified passphrase when provided' do
    command = subject.class.new

    expect(Open4).to(
        receive(:spawn)
            .with(/^#{binary}.* --passphrase "some-passphrase" .*#{command_string}$/,
                any_args))

    command.execute(
        options.merge(passphrase: 'some-passphrase'))
  end
end
