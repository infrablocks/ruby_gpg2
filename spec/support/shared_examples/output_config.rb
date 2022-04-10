# frozen_string_literal: true

shared_examples(
  'a command with output config'
) do |command_name, arguments = [], options = {}|
  let(:arguments_string) do
    arguments.empty? ? '' : " #{arguments.join(' ')}"
  end

  let(:command_string) { "#{command_name}#{arguments_string}" }
  let(:binary) { 'path/to/binary' }

  it 'does not include any output option by default' do
    command = described_class.new

    allow(Open4).to(receive(:spawn))

    command.execute(options)

    expect(Open4)
      .to(have_received(:spawn)
            .with(/^#{binary} ((?!--output).)*#{command_string}$/,
                  any_args))
  end

  it 'passes the specified output path when provided' do
    command = described_class.new

    output_file_path = 'some/path/to/output'

    allow(Open4).to(receive(:spawn))

    command.execute(
      options.merge(output_file_path: output_file_path)
    )

    command_pattern =
      /^#{binary}.* --output "#{output_file_path}" .*#{command_string}$/

    expect(Open4)
      .to(have_received(:spawn)
            .with(command_pattern, any_args))
  end
end
