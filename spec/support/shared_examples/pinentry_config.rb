# frozen_string_literal: true

shared_examples(
  'a command with pinentry config'
) do |command_name, arguments = [], options = {}|
  let(:arguments_string) do
    arguments.empty? ? '' : " #{arguments.join(' ')}"
  end

  let(:command_string) { "#{command_name}#{arguments_string}" }
  let(:binary) { 'path/to/binary' }

  it 'does not include any pinentry mode by default' do
    command = described_class.new

    allow(Open4).to(receive(:spawn))

    command.execute(options)

    expect(Open4)
      .to(have_received(:spawn)
            .with(/^#{binary}.* ((?!--pinentry-mode).)*#{command_string}$/,
                  any_args))
  end

  it 'uses the specified pinentry mode when provided' do
    command = described_class.new

    allow(Open4).to(receive(:spawn))

    command.execute(
      options.merge(pinentry_mode: :loopback)
    )

    expect(Open4)
      .to(have_received(:spawn)
            .with(/^#{binary}.* --pinentry-mode loopback .*#{command_string}$/,
                  any_args))
  end
end
