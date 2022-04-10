# frozen_string_literal: true

shared_examples(
  'a command with armor config'
) do |command_name, arguments = [], options = {}|
  let(:arguments_string) do
    arguments.empty? ? '' : " #{arguments.join(' ')}"
  end

  let(:command_string) { "#{command_name}#{arguments_string}" }
  let(:binary) { 'path/to/binary' }

  it 'does not include the armor flag by default' do
    command = described_class.new

    allow(Open4).to(receive(:spawn))

    command.execute(options)

    expect(Open4)
      .to(have_received(:spawn)
            .with(/^#{binary} ((?!--armor).)*#{command_string}$/,
                  any_args))
  end

  it 'does not include the armor flag when armor is false' do
    command = described_class.new

    allow(Open4).to(receive(:spawn))

    command.execute(
      options.merge(armor: false)
    )

    expect(Open4)
      .to(have_received(:spawn)
            .with(/^#{binary} ((?!--armor).)*#{command_string}$/,
                  any_args))
  end

  it 'includes the armor flag when batch is true' do
    command = described_class.new

    allow(Open4).to(receive(:spawn))

    command.execute(
      options.merge(armor: true)
    )

    expect(Open4)
      .to(have_received(:spawn)
            .with(/^#{binary}.* --armor .*#{command_string}$/,
                  any_args))
  end
end
