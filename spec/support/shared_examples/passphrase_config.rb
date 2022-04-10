# frozen_string_literal: true

shared_examples(
  'a command with passphrase config'
) do |command_name, arguments = [], options = {}|
  let(:arguments_string) do
    arguments.empty? ? '' : " #{arguments.join(' ')}"
  end

  let(:command_string) { "#{command_name}#{arguments_string}" }
  let(:binary) { 'path/to/binary' }

  it 'does not include any passphrase by default' do
    command = described_class.new

    allow(Open4).to(receive(:spawn))

    command.execute(options)

    expect(Open4)
      .to(have_received(:spawn)
            .with(/^#{binary}.* ((?!--passphrase).)*#{command_string}$/,
                  any_args))
  end

  it 'passes the specified passphrase when provided' do
    command = described_class.new

    allow(Open4).to(receive(:spawn))

    command.execute(
      options.merge(passphrase: 'some-passphrase')
    )

    command_pattern =
      /^#{binary}.* --passphrase "some-passphrase" .*#{command_string}$/

    expect(Open4)
      .to(have_received(:spawn)
            .with(command_pattern, any_args))
  end
end
