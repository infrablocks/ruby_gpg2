# frozen_string_literal: true

shared_examples(
  'a command with captured status'
) do |command_name, status_lines, arguments = [], options = {}|
  let(:arguments_string) do
    arguments.empty? ? '' : " #{arguments.join(' ')}"
  end

  let(:command_string) { "#{command_name}#{arguments_string}" }
  let(:binary) { 'path/to/binary' }

  it 'does not include a status file by default' do
    command = described_class.new

    allow(Open4).to(receive(:spawn))

    command.execute(options)

    expect(Open4)
      .to(have_received(:spawn)
            .with(/^#{binary} ((?!--status-file).)*#{command_string}$/,
                  any_args))
  end

  it 'includes a status file when with_status is true' do
    command = described_class.new

    allow(Open4).to(receive(:spawn))

    command.execute(
      options.merge(with_status: true)
    )

    expect(Open4)
      .to(have_received(:spawn)
            .with(/^#{binary}.* --status-file .*#{command_string}$/,
                  any_args))
  end

  it 'includes a status file when with_status is false' do
    command = described_class.new

    allow(Open4).to(receive(:spawn))

    command.execute(
      options.merge(with_status: false)
    )

    expect(Open4)
      .to(have_received(:spawn)
            .with(/^#{binary} ((?!--status-file).)*#{command_string}$/,
                  any_args))
  end

  it 'parses the status by default' do
    command = described_class.new

    status_file = instance_double(File)

    allow(status_file).to(receive(:path).and_return('some/path'))
    allow(Tempfile)
      .to(receive(:create)
            .with('status-file', nil)
            .and_yield(status_file))
    allow(Open4).to(
      receive(:spawn)
          .with(
            %r{^#{binary}.* --status-file "some/path" .*#{command_string}$},
            any_args
          )
    )
    allow(File)
      .to(receive(:read)
            .with(status_file.path)
            .and_return(status_lines.join("\n")))

    result = command.execute(options.merge(with_status: true))

    expect(result.status)
      .to(eq(RubyGPG2::StatusOutput.parse(status_lines.join("\n"))))
  end

  it 'creates a temp file for status in the provided work directory ' \
     'when present' do
    command = described_class.new

    status_file = instance_double(File)
    work_directory = 'some/work/directory'

    allow(status_file)
      .to(receive(:path)
            .and_return('some/path'))
    allow(Tempfile)
      .to(receive(:create)
            .with('status-file', work_directory)
            .and_yield(status_file))
    allow(Open4).to(
      receive(:spawn)
          .with(
            %r{^#{binary}.* --status-file "some/path" .*#{command_string}$},
            any_args
          )
    )
    allow(File)
      .to(receive(:read)
            .with(status_file.path)
            .and_return(status_lines.join("\n")))

    result = command.execute(
      options.merge(
        with_status: true,
        work_directory: work_directory
      )
    )

    expect(result.status)
      .to(eq(RubyGPG2::StatusOutput.parse(status_lines.join("\n"))))
  end

  it 'leaves status un-parsed when requested' do
    command = described_class.new

    status_file = instance_double(File)

    allow(status_file).to(receive(:path).and_return('some/path'))
    allow(Tempfile).to(receive(:create).and_yield(status_file))
    allow(Open4).to(
      receive(:spawn)
          .with(
            %r{^#{binary}.* --status-file "some/path" .*#{command_string}$},
            any_args
          )
    )
    allow(File)
      .to(receive(:read)
            .with(status_file.path)
            .and_return(status_lines.join("\n")))

    result = command.execute(
      with_status: true,
      parse_status: false
    )

    expect(result.status).to(eq(status_lines.join("\n")))
  end
end
