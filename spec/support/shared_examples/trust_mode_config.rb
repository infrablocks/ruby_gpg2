# frozen_string_literal: true

shared_examples(
  'a command with trust mode config'
) do |command_name, arguments = [], options = {}|
  let(:arguments_string) do
    arguments.empty? ? '' : " #{arguments.join(' ')}"
  end

  let(:command_string) { "#{command_name}#{arguments_string}" }
  let(:binary) { 'path/to/binary' }

  it 'does not include any trust mode option by default' do
    command = described_class.new

    allow(Open4).to(receive(:spawn))

    command.execute(options)

    expect(Open4)
      .to(have_received(:spawn)
            .with(/^#{binary} ((?!--trust-mode).)*#{command_string}$/,
                  any_args))
  end

  it 'passes the specified trust mode when provided' do
    command = described_class.new

    trust_mode = :always

    allow(Open4).to(receive(:spawn))

    command.execute(
      options.merge(trust_mode: trust_mode)
    )

    expect(Open4)
      .to(have_received(:spawn)
            .with(
              /^#{binary}.* --trust-mode #{trust_mode} .*#{command_string}$/,
              any_args
            ))
  end
end
