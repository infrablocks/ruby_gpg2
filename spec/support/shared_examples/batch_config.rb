shared_examples(
    "a command with batch config"
) do |command_name, arguments = [], options = {}|
  let(:arguments_string) do
    arguments.empty? ? "" : " #{arguments.join(" ")}"
  end

  let(:command_string) { "#{command_name}#{arguments_string}" }
  let(:binary) { "path/to/binary" }

  it 'includes the batch flag by default' do
    command = subject.class.new

    expect(Open4).to(
        receive(:spawn)
            .with(/^#{binary}.* --batch .*#{command_string}$/,
                any_args))

    command.execute(options)
  end

  it 'does not include the batch flag when batch is false' do
    command = subject.class.new

    expect(Open4).to(
        receive(:spawn)
            .with(/^#{binary} ((?!--batch).)*#{command_string}$/,
                any_args))

    command.execute(
        options.merge(batch: false))
  end

  it 'includes the batch flag when batch is true' do
    command = subject.class.new

    expect(Open4).to(
        receive(:spawn)
            .with(/^#{binary}.* --batch .*#{command_string}$/,
                any_args))

    command.execute(
        options.merge(batch: true))
  end
end
