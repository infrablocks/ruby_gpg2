# frozen_string_literal: true

shared_examples(
  'a command with batch config'
) do |command_name, arguments = [], options = {}|
  let(:arguments_string) do
    arguments.empty? ? '' : " #{arguments.join(' ')}"
  end

  let(:command_string) { "#{command_name}#{arguments_string}" }
  let(:binary) { 'path/to/binary' }

  it 'includes the batch flag by default' do
    command = described_class.new

    allow(Open4).to(receive(:spawn))

    command.execute(options)

    expect(Open4)
      .to(have_received(:spawn)
            .with(/^#{binary}.* --batch .*#{command_string}$/,
                  any_args))
  end

  it 'does not include the batch flag when batch is false' do
    command = described_class.new

    allow(Open4).to(receive(:spawn))

    command.execute(
      options.merge(batch: false)
    )

    expect(Open4)
      .to(have_received(:spawn)
            .with(/^#{binary} ((?!--batch).)*#{command_string}$/,
                  any_args))
  end

  it 'includes the batch flag when batch is true' do
    command = described_class.new

    allow(Open4).to(receive(:spawn))

    command.execute(
      options.merge(batch: true)
    )

    expect(Open4)
      .to(have_received(:spawn)
            .with(/^#{binary}.* --batch .*#{command_string}$/,
                  any_args))
  end
end
