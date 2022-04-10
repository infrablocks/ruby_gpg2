# frozen_string_literal: true

require 'spec_helper'

describe RubyGPG2::ParameterFileContents do
  describe 'initialize' do
    it 'defaults the key type to RSA' do
      parameter_file =
        described_class
        .new({
               owner_name: 'Cara Smith',
               owner_email: 'cara.smith@example.com'
             })

      expect(parameter_file.key_type).to(eq('RSA'))
    end

    it 'uses the specified key type when provided' do
      key_type = 'DSA'

      parameter_file =
        described_class
        .new({
               owner_name: 'Cara Smith',
               owner_email: 'cara.smith@example.com',
               key_type: key_type
             })

      expect(parameter_file.key_type).to(eq(key_type))
    end

    it 'defaults to a key length of 2048' do
      parameter_file =
        described_class
        .new({
               owner_name: 'Cara Smith',
               owner_email: 'cara.smith@example.com'
             })

      expect(parameter_file.key_length).to(eq(2048))
    end

    it 'uses the specified key length when provided' do
      key_length = 4096

      parameter_file =
        described_class
        .new({
               owner_name: 'Cara Smith',
               owner_email: 'cara.smith@example.com',
               key_length: key_length
             })

      expect(parameter_file.key_length).to(eq(key_length))
    end

    it 'defaults the subkey type to RSA' do
      parameter_file =
        described_class
        .new({
               owner_name: 'Cara Smith',
               owner_email: 'cara.smith@example.com'
             })

      expect(parameter_file.subkey_type).to(eq('RSA'))
    end

    it 'uses the specified subkey type when provided' do
      subkey_type = 'ELG'

      parameter_file =
        described_class
        .new({
               owner_name: 'Cara Smith',
               owner_email: 'cara.smith@example.com',
               subkey_type: subkey_type
             })

      expect(parameter_file.subkey_type).to(eq(subkey_type))
    end

    it 'defaults to a subkey length of 2048' do
      parameter_file =
        described_class
        .new({
               owner_name: 'Cara Smith',
               owner_email: 'cara.smith@example.com'
             })

      expect(parameter_file.subkey_length).to(eq(2048))
    end

    it 'uses the specified subkey length when provided' do
      subkey_length = 4096

      parameter_file =
        described_class
        .new({
               owner_name: 'Cara Smith',
               owner_email: 'cara.smith@example.com',
               subkey_length: subkey_length
             })

      expect(parameter_file.subkey_length).to(eq(subkey_length))
    end

    it 'uses the specified owner name' do
      owner_name = 'Cara Smith'

      parameter_file =
        described_class
        .new({
               owner_name: owner_name,
               owner_email: 'cara.smith@example.com'
             })

      expect(parameter_file.owner_name).to(eq(owner_name))
    end

    it 'raises an exception if no owner name is provided' do
      owner_name = nil

      expect do
        described_class
          .new({
                 owner_name: owner_name,
                 owner_email: 'cara.smith@example.com'
               })
      end.to(raise_error(
               RuntimeError,
               'Missing required parameter: [:owner_name].'
             ))
    end

    it 'uses the specified owner email' do
      owner_email = 'cara.smith@example.com'

      parameter_file =
        described_class
        .new({
               owner_name: 'Cara Smith',
               owner_email: owner_email
             })

      expect(parameter_file.owner_email).to(eq(owner_email))
    end

    it 'raises an exception if no owner email is provided' do
      owner_email = nil

      expect do
        described_class
          .new({
                 owner_name: 'Cara Smith',
                 owner_email: owner_email
               })
      end.to(raise_error(
               RuntimeError,
               'Missing required parameter: [:owner_email].'
             ))
    end

    it 'has no owner comment by default' do
      parameter_file =
        described_class
        .new({
               owner_name: 'Cara Smith',
               owner_email: 'cara.smith@example.com'
             })

      expect(parameter_file.owner_comment).to(be_nil)
    end

    it 'uses the specified owner comment when provided' do
      owner_comment = 'Work'

      parameter_file =
        described_class
        .new({
               owner_name: 'Cara Smith',
               owner_email: 'cara.smith@example.com',
               owner_comment: owner_comment
             })

      expect(parameter_file.owner_comment).to(eq(owner_comment))
    end

    it 'has an expiry of never by default' do
      parameter_file =
        described_class
        .new({
               owner_name: 'Cara Smith',
               owner_email: 'cara.smith@example.com'
             })

      expect(parameter_file.expiry).to(eq(:never))
    end

    it 'uses the specified expiry when provided' do
      expiry = '2y'

      parameter_file =
        described_class
        .new({
               owner_name: 'Cara Smith',
               owner_email: 'cara.smith@example.com',
               expiry: expiry
             })

      expect(parameter_file.expiry).to(eq(expiry))
    end

    it 'has no passphrase by default' do
      parameter_file =
        described_class
        .new({
               owner_name: 'Cara Smith',
               owner_email: 'cara.smith@example.com'
             })

      expect(parameter_file.passphrase).to(be_nil)
    end

    it 'uses the specified passphrase when provided' do
      passphrase = 'super-secret-123'

      parameter_file =
        described_class
        .new({
               owner_name: 'Cara Smith',
               owner_email: 'cara.smith@example.com',
               passphrase: passphrase
             })

      expect(parameter_file.passphrase).to(eq(passphrase))
    end
  end

  describe 'to_s' do
    it 'includes all parameters when specified' do
      parameter_file =
        described_class
        .new({
               key_type: 'DSA',
               key_length: 4096,
               subkey_type: 'ELG',
               subkey_length: 4096,
               owner_name: 'Cara Smith',
               owner_email: 'cara.smith@example.com',
               owner_comment: 'Work',
               expiry: '2y',
               passphrase: 'super-secret-123'
             })

      expect(parameter_file.to_s)
        .to(eq(
              <<~PARAMS
                Key-Type: DSA
                Key-Length: 4096
                Subkey-Type: ELG
                Subkey-Length: 4096
                Name-Real: Cara Smith
                Name-Comment: Work
                Name-Email: cara.smith@example.com
                Expire-Date: 2y
                Passphrase: super-secret-123
              PARAMS
            ))
    end

    it 'does not include unspecified parameters' do
      parameter_file =
        described_class
        .new({
               owner_name: 'Cara Smith',
               owner_email: 'cara.smith@example.com',
               expiry: '2y'
             })

      expect(parameter_file.to_s)
        .to(eq(
              <<~PARAMS
                Key-Type: RSA
                Key-Length: 2048
                Subkey-Type: RSA
                Subkey-Length: 2048
                Name-Real: Cara Smith
                Name-Email: cara.smith@example.com
                Expire-Date: 2y
              PARAMS
            ))
    end

    it 'uses an expire-date of 0 when expiry is :never' do
      parameter_file =
        described_class
        .new({
               owner_name: 'Cara Smith',
               owner_email: 'cara.smith@example.com'
             })

      expect(parameter_file.to_s).to(include('Expire-Date: 0'))
    end

    # rubocop:disable RSpec/MultipleExpectations
    it 'does not include key length when key type is default' do
      parameter_file =
        described_class
        .new({
               owner_name: 'Cara Smith',
               owner_email: 'cara.smith@example.com',
               key_type: :default
             })

      parameter_file_contents = parameter_file.to_s

      expect(parameter_file_contents).to(include('Key-Type: default'))
      expect(parameter_file_contents).not_to(include('Key-Length'))
    end
    # rubocop:enable RSpec/MultipleExpectations

    # rubocop:disable RSpec/MultipleExpectations
    it 'does not include subkey length when subkey type is default' do
      parameter_file =
        described_class
        .new({
               owner_name: 'Cara Smith',
               owner_email: 'cara.smith@example.com',
               subkey_type: :default
             })

      parameter_file_contents = parameter_file.to_s

      expect(parameter_file_contents).to(include('Subkey-Type: default'))
      expect(parameter_file_contents).not_to(include('Subkey-Length'))
    end
    # rubocop:enable RSpec/MultipleExpectations

    # rubocop:disable RSpec/MultipleExpectations
    it 'does not include subkey length when subkey type is nil' do
      parameter_file =
        described_class
        .new({
               owner_name: 'Cara Smith',
               owner_email: 'cara.smith@example.com',
               subkey_type: nil
             })

      parameter_file_contents = parameter_file.to_s

      expect(parameter_file_contents).not_to(include('Subkey-Type'))
      expect(parameter_file_contents).not_to(include('Subkey-Length'))
    end
    # rubocop:enable RSpec/MultipleExpectations
  end

  describe 'write_to' do
    # rubocop:disable RSpec/MultipleExpectations
    it 'writes the contents to the specified path' do
      path = 'some/path'

      file = instance_double(File)
      allow(File).to(receive(:open).and_yield(file))
      allow(file).to(receive(:write))

      described_class
        .new(
          owner_name: 'Cara Smith',
          owner_email: 'cara.smith@example.com'
        )
        .write_to(path)

      expected_params =
        <<~PARAMS
          Key-Type: RSA
          Key-Length: 2048
          Subkey-Type: RSA
          Subkey-Length: 2048
          Name-Real: Cara Smith
          Name-Email: cara.smith@example.com
          Expire-Date: 0
        PARAMS

      expect(File)
        .to(have_received(:open)
              .with(path, 'w'))
      expect(file)
        .to(have_received(:write)
              .with(expected_params))
    end
    # rubocop:enable RSpec/MultipleExpectations
  end

  describe 'in_temp_file' do
    # rubocop:disable RSpec/MultipleExpectations
    it 'writes the contents to a temp file under the specified path and ' \
       'executes the block with the file' do
      path = 'some/directory'

      file = instance_double(File)
      allow(Tempfile).to(receive(:create).and_yield(file))
      allow(file).to(receive(:write))
      allow(file).to(receive(:flush))

      captured_file = nil

      described_class
        .new(
          owner_name: 'Cara Smith',
          owner_email: 'cara.smith@example.com'
        )
        .in_temp_file(path) do |f|
        captured_file = f
      end

      expected_params =
        <<~PARAMS
          Key-Type: RSA
          Key-Length: 2048
          Subkey-Type: RSA
          Subkey-Length: 2048
          Name-Real: Cara Smith
          Name-Email: cara.smith@example.com
          Expire-Date: 0
        PARAMS

      expect(Tempfile)
        .to(have_received(:create)
              .with('parameter-file', path))
      expect(file)
        .to(have_received(:write)
              .with(expected_params))
      expect(file)
        .to(have_received(:flush))
      expect(captured_file).to(be(file))
    end
    # rubocop:enable RSpec/MultipleExpectations

    # rubocop:disable RSpec/MultipleExpectations
    it 'uses the default tmpdir by default' do
      file = instance_double(File)
      allow(Tempfile).to(receive(:create).and_yield(file))
      allow(file).to(receive(:write))
      allow(file).to(receive(:flush))

      captured_file = nil

      described_class
        .new(
          owner_name: 'Cara Smith',
          owner_email: 'cara.smith@example.com'
        )
        .in_temp_file do |f|
        captured_file = f
      end

      expect(Tempfile)
        .to(have_received(:create)
              .with('parameter-file', nil))
      expect(captured_file).to(be(file))
    end
    # rubocop:enable RSpec/MultipleExpectations
  end
end
