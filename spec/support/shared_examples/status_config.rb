# frozen_string_literal: true

shared_examples(
  'a command with status config'
) do |command_name, arguments = [], options = {}|
  let(:arguments_string) do
    arguments.empty? ? '' : " #{arguments.join(' ')}"
  end

  let(:command_string) { "#{command_name}#{arguments_string}" }
  let(:binary) { 'path/to/binary' }

  it 'does not include the status file option by default' do
    command = described_class.new

    allow(Open4).to(receive(:spawn))

    command.execute(options)

    expect(Open4)
      .to(have_received(:spawn)
            .with(/^#{binary}.* ((?!--status-file).)*#{command_string}$/,
                  any_args))
  end

  it 'includes the specified status file when provided' do
    command = described_class.new

    allow(Open4).to(receive(:spawn))

    command.execute(
      options.merge(status_file: 'some/status/file')
    )

    command_pattern =
      %r{^#{binary}.* --status-file "some/status/file" .*#{command_string}$}

    expect(Open4)
      .to(have_received(:spawn)
            .with(command_pattern, any_args))
  end
end
