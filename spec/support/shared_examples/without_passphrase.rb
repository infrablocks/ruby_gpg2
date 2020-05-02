shared_examples(
    "a command allowing no passphrase"
) do |command_name, arguments = [], options = {}|
  let(:arguments_string) do
    arguments.empty? ? "" : " #{arguments.join(" ")}"
  end

  let(:command_string) { "#{command_name}#{arguments_string}" }
  let(:binary) { "path/to/binary" }

  it 'uses an empty passphrase when without_passphrase is true' do
    command = subject.class.new

    expect(Open4).to(
        receive(:spawn)
            .with(/^#{binary}.* --passphrase='' .*#{command_string}$/,
                any_args))

    command.execute(
        options.merge(without_passphrase: true))
  end

  it 'uses loopback pinentry mode when without_passphrase is true' do
    command = subject.class.new

    expect(Open4).to(
        receive(:spawn)
            .with(/^#{binary}.* --pinentry-mode=loopback .*#{command_string}$/,
                any_args))

    command.execute(
        options.merge(without_passphrase: true))
  end

  it 'does not include any passphrase when without_passphrase is false' do
    command = subject.class.new

    expect(Open4).to(
        receive(:spawn)
            .with(/^#{binary}.* ((?!--passphrase).)*#{command_string}$/,
                any_args))

    command.execute(
        options.merge(without_passphrase: false))
  end

  it 'does not include any pinentry mode when without_passphrase is false' do
    command = subject.class.new

    expect(Open4).to(
        receive(:spawn)
            .with(/^#{binary}.* ((?!--pinentry-mode).)*#{command_string}$/,
                any_args))

    command.execute(
        options.merge(without_passphrase: false))
  end
end