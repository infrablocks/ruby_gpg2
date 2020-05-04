shared_examples(
    "a command with captured output"
) do |command_name, records, arguments = [], options = {}|
  let(:arguments_string) do
    arguments.empty? ? "" : " #{arguments.join(" ")}"
  end

  let(:command_string) { "#{command_name}#{arguments_string}" }
  let(:binary) { "path/to/binary" }

  it 'parses the output by default' do
    command = subject.class.new

    expect(Open4).to(
        receive(:spawn)
            .with(/^#{binary}.* --with-colons .*#{command_string}$/,
                any_args) { |_, opts|
              opts[:stdout].write(records.join("\n"))
            })

    result = command.execute(options)

    expect(result.output)
        .to(eq(RubyGPG2::ColonOutput.parse(records.join("\n"))))
  end

  it 'leaves output un-parsed when requested' do
    command = subject.class.new

    expect(Open4).to(
        receive(:spawn)
            .with(/^#{binary}.* --with-colons .*#{command_string}$/,
                any_args) { |_, opts|
              opts[:stdout].write(records.join("\n"))
            })

    result = command.execute(
        with_colons: true,
        parse_output: false)

    expect(result.output).to(eq(records.join("\n")))
  end
end
