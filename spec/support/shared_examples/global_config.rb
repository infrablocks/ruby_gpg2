# frozen_string_literal: true

shared_examples(
  'a command with global config'
) do |command_name, arguments = [], options = {}|
  let(:arguments_string) do
    arguments.empty? ? '' : " #{arguments.join(' ')}"
  end

  let(:command_string) { "#{command_name}#{arguments_string}" }
  let(:binary) { 'path/to/binary' }

  it 'does not set a home directory by default' do
    command = subject.class.new

    allow(Open4).to(receive(:spawn))

    command.execute(options)

    expect(Open4)
      .to(have_received(:spawn)
            .with(
              /^#{binary} ((?!--homedir).)*#{command_string}$/,
              any_args
            ))
  end

  it 'includes the provided home directory' do
    home_directory = './gpg'

    command = subject.class.new

    allow(Open4).to(receive(:spawn))

    command.execute(
      options.merge(home_directory: home_directory)
    )

    expect(Open4)
      .to(have_received(:spawn)
            .with(
              /^#{binary}.* --homedir "#{home_directory}" .*#{command_string}$/,
              any_args
            ))
  end

  it 'includes the no-tty flag by default' do
    command = subject.class.new

    allow(Open4).to(receive(:spawn))

    command.execute(options)

    expect(Open4)
      .to(have_received(:spawn)
            .with(
              /^#{binary}.* --no-tty .*#{command_string}$/,
              any_args
            ))
  end

  it 'includes the no-tty flag when without tty is true' do
    command = subject.class.new

    allow(Open4).to(receive(:spawn))

    command.execute(
      options.merge(without_tty: true)
    )

    expect(Open4)
      .to(have_received(:spawn)
            .with(
              /^#{binary}.* --no-tty .*#{command_string}$/,
              any_args
            ))
  end

  it 'does not include the no-tty flag when without tty is false' do
    command = subject.class.new

    allow(Open4).to(receive(:spawn))

    command.execute(
      options.merge(without_tty: false)
    )

    expect(Open4)
      .to(have_received(:spawn)
            .with(
              /^#{binary} ((?!--no-tty).)*#{command_string}$/,
              any_args
            ))
  end
end
