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

  it 'parses the output by default' do
    command = subject.class.new

    colon_record_1 =
        'pub:u:2048:1:1A16916844CE9D82:1333003000:::u:::scESC::::::23::0:'
    colon_record_2 =
        'fpr:::::::::41D2606F66C3FF28874362B61A16916844CE9D82:'

    expect(Open4).to(
        receive(:spawn)
            .with(/^#{binary}.* --with-colons .*#{command_string}$/,
                any_args) { |_, opts|
              opts[:stdout].write("#{colon_record_1}\n#{colon_record_2}\n")
            })

    result = command.execute

    expect(result)
        .to(eq(RubyGPG2::ColonOutput.new([
            RubyGPG2::ColonRecord.parse(colon_record_1),
            RubyGPG2::ColonRecord.parse(colon_record_2)
        ])))
  end

  it 'leaves output un-parsed when requested' do
    command = subject.class.new

    colon_record_1 =
        'pub:u:2048:1:1A16916844CE9D82:1333003000:::u:::scESC::::::23::0:'
    colon_record_2 =
        'fpr:::::::::41D2606F66C3FF28874362B61A16916844CE9D82:'

    expect(Open4).to(
        receive(:spawn)
            .with(/^#{binary}.* --with-colons .*#{command_string}$/,
                any_args) { |_, opts|
              opts[:stdout].write("#{colon_record_1}\n#{colon_record_2}\n")
            })

    result = command.execute(
        with_colons: true,
        parse_output: false)

    expect(result).to(eq("#{colon_record_1}\n#{colon_record_2}\n"))
  end
end
