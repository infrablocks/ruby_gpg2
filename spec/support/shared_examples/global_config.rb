shared_examples(
    "a command with global config"
) do |command_name, arguments = [], options = {}|
  let(:argument_string) do
    arguments.empty? ? "" : " #{arguments.join(" ")}"
  end

  it 'includes the batch flag by default' do
    command = subject.class.new

    expect(Open4).to(
        receive(:spawn)
            .with("path/to/binary --batch " +
                "#{command_name}#{argument_string}",
                any_args))

    command.execute(options)
  end

  it 'does not include the batch flag when batch is false' do
    command = subject.class.new

    expect(Open4).to(
        receive(:spawn)
            .with("path/to/binary #{command_name}#{argument_string}",
                any_args))

    command.execute(
        options.merge(batch: false))
  end

  it 'includes the batch flag when batch is true' do
    command = subject.class.new

    expect(Open4).to(
        receive(:spawn)
            .with("path/to/binary --batch #{command_name}#{argument_string}",
                any_args))

    command.execute(
        options.merge(batch: true))
  end

  it 'does not set a home directory by default' do
    command = subject.class.new

    expect(Open4).to(
        receive(:spawn)
            .with("path/to/binary --batch #{command_name}#{argument_string}",
                any_args))

    command.execute(options)
  end

  it 'includes the provided home directory' do
    home_directory = './gpg'

    command = subject.class.new

    expect(Open4).to(
        receive(:spawn)
            .with("path/to/binary --batch --homedir=\"#{home_directory}\" " +
                "#{command_name}#{argument_string}",
                any_args))

    command.execute(
        options.merge(home_directory: home_directory))
  end
end
