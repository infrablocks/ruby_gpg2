shared_examples(
    "a command with armor config"
) do |command_name, arguments = [], options = {}|
  let(:arguments_string) do
    arguments.empty? ? "" : " #{arguments.join(" ")}"
  end

  let(:command_string) { "#{command_name}#{arguments_string}" }
  let(:binary) { "path/to/binary" }

  it 'does not include the armor flag by default' do
    command = subject.class.new

    expect(Open4).to(
        receive(:spawn)
            .with(/^#{binary} ((?!--armor).)*#{command_string}$/,
                any_args))

    command.execute(options)
  end

  it 'does not include the armor flag when armor is false' do
    command = subject.class.new

    expect(Open4).to(
        receive(:spawn)
            .with(/^#{binary} ((?!--armor).)*#{command_string}$/,
                any_args))

    command.execute(
        options.merge(armor: false))
  end

  it 'includes the armor flag when batch is true' do
    command = subject.class.new

    expect(Open4).to(
        receive(:spawn)
            .with(/^#{binary}.* --armor .*#{command_string}$/,
                any_args))

    command.execute(
        options.merge(armor: true))
  end
end
