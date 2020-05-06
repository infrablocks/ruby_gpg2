shared_examples(
    "a command with trust mode config"
) do |command_name, arguments = [], options = {}|
  let(:arguments_string) do
    arguments.empty? ? "" : " #{arguments.join(" ")}"
  end

  let(:command_string) { "#{command_name}#{arguments_string}" }
  let(:binary) { "path/to/binary" }

  it 'does not include any trust mode option by default' do
    command = subject.class.new

    expect(Open4).to(
        receive(:spawn)
            .with(/^#{binary} ((?!--trust-mode).)*#{command_string}$/,
                any_args))

    command.execute(options)
  end

  it 'passes the specified trust mode when provided' do
    command = subject.class.new

    trust_mode = :always

    expect(Open4).to(
        receive(:spawn)
            .with(
                /^#{binary}.* --trust-mode #{trust_mode.to_s} .*#{command_string}$/,
                any_args))

    command.execute(
        options.merge(trust_mode: trust_mode))
  end
end
