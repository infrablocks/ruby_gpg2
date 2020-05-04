shared_examples(
    "a command with colon config"
) do |command_name, arguments = [], options = {}|
  let(:arguments_string) do
    arguments.empty? ? "" : " #{arguments.join(" ")}"
  end

  let(:command_string) { "#{command_name}#{arguments_string}" }
  let(:binary) { "path/to/binary" }

  it 'includes the colon flag by default' do
    command = subject.class.new

    expect(Open4).to(
        receive(:spawn)
            .with(/^#{binary}.* --with-colons .*#{command_string}$/,
                any_args))

    command.execute(options)
  end

  it 'does not include the colon flag when with colons is false' do
    command = subject.class.new

    expect(Open4).to(
        receive(:spawn)
            .with(/^#{binary} ((?! --with-colons).)*#{command_string}$/,
                any_args))

    command.execute(
        options.merge(with_colons: false))
  end

  it 'includes the colon flag when with colons is true' do
    command = subject.class.new

    expect(Open4).to(
        receive(:spawn)
            .with(/^#{binary}.* --with-colons .*#{command_string}$/,
                any_args))

    command.execute(
        options.merge(with_colons: true))
  end
end
