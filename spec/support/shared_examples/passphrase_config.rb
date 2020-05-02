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

  it 'uses an empty passphrase when without_passphrase is true' do
    command = subject.class.new

    expect(Open4).to(
        receive(:spawn)
            .with(/^#{binary}.* --passphrase='' .*#{command_string}$/,
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

  it 'passes the specified passphrase when provided' do
    command = subject.class.new

    expect(Open4).to(
        receive(:spawn)
            .with(/^#{binary}.* --passphrase='some-passphrase' .*#{command_string}$/,
                any_args))

    command.execute(
        options.merge(passphrase: 'some-passphrase'))
  end

  it 'allows a specified passphrase to take precedence over without_passphrase' do
    command = subject.class.new

    expect(Open4).to(
        receive(:spawn)
            .with(/^#{binary}.* --passphrase='some-passphrase' .*#{command_string}$/,
                any_args))

    command.execute(
        options.merge(
            passphrase: 'some-passphrase',
            without_passphrase: true))
  end
end
