require 'spec_helper'

describe RubyGPG2::ParameterFile do
  context 'initialize' do
    it 'defaults the key type to RSA' do
      parameter_file = RubyGPG2::ParameterFile.new({
          owner_name: 'Cara Smith',
          owner_email: 'cara.smith@example.com'
      })

      expect(parameter_file.key_type).to(eq('RSA'))
    end

    it 'uses the specified key type when provided' do
      key_type = 'DSA'

      parameter_file = RubyGPG2::ParameterFile.new({
          owner_name: 'Cara Smith',
          owner_email: 'cara.smith@example.com',
          key_type: key_type
      })

      expect(parameter_file.key_type).to(eq(key_type))
    end

    it 'defaults to a key length of 2048' do
      parameter_file = RubyGPG2::ParameterFile.new({
          owner_name: 'Cara Smith',
          owner_email: 'cara.smith@example.com'
      })

      expect(parameter_file.key_length).to(eq(2048))
    end

    it 'uses the specified key length when provided' do
      key_length = 4096

      parameter_file = RubyGPG2::ParameterFile.new({
          owner_name: 'Cara Smith',
          owner_email: 'cara.smith@example.com',
          key_length: key_length
      })

      expect(parameter_file.key_length).to(eq(key_length))
    end

    it 'defaults the subkey type to RSA' do
      parameter_file = RubyGPG2::ParameterFile.new({
          owner_name: 'Cara Smith',
          owner_email: 'cara.smith@example.com'
      })

      expect(parameter_file.subkey_type).to(eq('RSA'))
    end

    it 'uses the specified subkey type when provided' do
      subkey_type = 'ELG'

      parameter_file = RubyGPG2::ParameterFile.new({
          owner_name: 'Cara Smith',
          owner_email: 'cara.smith@example.com',
          subkey_type: subkey_type
      })

      expect(parameter_file.subkey_type).to(eq(subkey_type))
    end

    it 'defaults to a subkey length of 2048' do
      parameter_file = RubyGPG2::ParameterFile.new({
          owner_name: 'Cara Smith',
          owner_email: 'cara.smith@example.com'
      })

      expect(parameter_file.subkey_length).to(eq(2048))
    end

    it 'uses the specified subkey length when provided' do
      subkey_length = 4096

      parameter_file = RubyGPG2::ParameterFile.new({
          owner_name: 'Cara Smith',
          owner_email: 'cara.smith@example.com',
          subkey_length: subkey_length
      })

      expect(parameter_file.subkey_length).to(eq(subkey_length))
    end

    it 'uses the specified owner email' do
      owner_name = 'Cara Smith'

      parameter_file = RubyGPG2::ParameterFile.new({
          owner_name: owner_name,
          owner_email: 'cara.smith@example.com'
      })

      expect(parameter_file.owner_name).to(eq(owner_name))
    end

    it 'raises an exception if no owner name is provided' do
      owner_name = nil

      expect {
        RubyGPG2::ParameterFile.new({
            owner_name: owner_name,
            owner_email: 'cara.smith@example.com'
        })
      }.to(raise_error(
          RuntimeError,
          "Missing required parameter: [:owner_name]."))
    end

    it 'uses the specified owner email' do
      owner_email = 'cara.smith@example.com'

      parameter_file = RubyGPG2::ParameterFile.new({
          owner_name: 'Cara Smith',
          owner_email: owner_email
      })

      expect(parameter_file.owner_email).to(eq(owner_email))
    end

    it 'raises an exception if no owner email is provided' do
      owner_email = nil

      expect {
        RubyGPG2::ParameterFile.new({
            owner_name: 'Cara Smith',
            owner_email: owner_email
        })
      }.to(raise_error(
          RuntimeError,
          "Missing required parameter: [:owner_email]."))
    end

    it 'has no owner comment by default' do
      parameter_file = RubyGPG2::ParameterFile.new({
          owner_name: 'Cara Smith',
          owner_email: 'cara.smith@example.com'
      })

      expect(parameter_file.owner_comment).to(be_nil)
    end

    it 'uses the specified owner comment when provided' do
      owner_comment = 'Work'

      parameter_file = RubyGPG2::ParameterFile.new({
          owner_name: 'Cara Smith',
          owner_email: 'cara.smith@example.com',
          owner_comment: owner_comment
      })

      expect(parameter_file.owner_comment).to(eq(owner_comment))
    end

    it 'has an expiry of never by default' do
      parameter_file = RubyGPG2::ParameterFile.new({
          owner_name: 'Cara Smith',
          owner_email: 'cara.smith@example.com'
      })

      expect(parameter_file.expiry).to(eq(:never))
    end

    it 'uses the specified expiry when provided' do
      expiry = '2y'

      parameter_file = RubyGPG2::ParameterFile.new({
          owner_name: 'Cara Smith',
          owner_email: 'cara.smith@example.com',
          expiry: expiry
      })

      expect(parameter_file.expiry).to(eq(expiry))
    end

    it 'has no passphrase by default' do
      parameter_file = RubyGPG2::ParameterFile.new({
          owner_name: 'Cara Smith',
          owner_email: 'cara.smith@example.com'
      })

      expect(parameter_file.passphrase).to(be_nil)
    end

    it 'uses the specified passphrase when provided' do
      passphrase = 'super-secret-123'

      parameter_file = RubyGPG2::ParameterFile.new({
          owner_name: 'Cara Smith',
          owner_email: 'cara.smith@example.com',
          passphrase: passphrase
      })

      expect(parameter_file.passphrase).to(eq(passphrase))
    end
  end

  context "to_s" do
    it 'includes all parameters when specified' do
      parameter_file = RubyGPG2::ParameterFile.new({
          key_type: 'DSA',
          key_length: 4096,
          subkey_type: 'ELG',
          subkey_length: 4096,
          owner_name: 'Cara Smith',
          owner_email: 'cara.smith@example.com',
          owner_comment: 'Work',
          expiry: '2y',
          passphrase: 'super-secret-123',
      })

      expect(parameter_file.to_s).to(eq(
          <<-EOF
Key-Type: DSA
Key-Length: 4096
Subkey-Type: ELG
Subkey-Length: 4096
Name-Real: Cara Smith
Name-Comment: Work
Name-Email: cara.smith@example.com
Expire-Date: 2y
Passphrase: super-secret-123
      EOF
      ))
    end

    it 'does not include unspecified parameters' do
      parameter_file = RubyGPG2::ParameterFile.new({
          owner_name: 'Cara Smith',
          owner_email: 'cara.smith@example.com',
          expiry: '2y'
      })

      expect(parameter_file.to_s).to(eq(
          <<-EOF
Key-Type: RSA
Key-Length: 2048
Subkey-Type: RSA
Subkey-Length: 2048
Name-Real: Cara Smith
Name-Email: cara.smith@example.com
Expire-Date: 2y
      EOF
      ))
    end

    it 'uses an expire-date of 0 when expiry is :never' do
      parameter_file = RubyGPG2::ParameterFile.new({
          owner_name: 'Cara Smith',
          owner_email: 'cara.smith@example.com'
      })

      expect(parameter_file.to_s).to(include("Expire-Date: 0"))
    end

    it 'does not include key length when key type is default' do
      parameter_file = RubyGPG2::ParameterFile.new({
          owner_name: 'Cara Smith',
          owner_email: 'cara.smith@example.com',
          key_type: :default
      })

      parameter_file_contents = parameter_file.to_s

      expect(parameter_file_contents).to(include("Key-Type: default"))
      expect(parameter_file_contents).not_to(include("Key-Length"))
    end

    it 'does not include subkey length when subkey type is default' do
      parameter_file = RubyGPG2::ParameterFile.new({
          owner_name: 'Cara Smith',
          owner_email: 'cara.smith@example.com',
          subkey_type: :default
      })

      parameter_file_contents = parameter_file.to_s

      expect(parameter_file_contents).to(include("Subkey-Type: default"))
      expect(parameter_file_contents).not_to(include("Subkey-Length"))
    end

    it 'does not include subkey length when subkey type is nil' do
      parameter_file = RubyGPG2::ParameterFile.new({
          owner_name: 'Cara Smith',
          owner_email: 'cara.smith@example.com',
          subkey_type: nil
      })

      parameter_file_contents = parameter_file.to_s

      expect(parameter_file_contents).not_to(include("Subkey-Type"))
      expect(parameter_file_contents).not_to(include("Subkey-Length"))
    end
  end

  context "write_to" do
    it 'writes the contents to the specified path' do
      path = 'some/path'

      file = double('file')
      expect(File)
          .to(receive(:open)
              .with(path, 'w')
              .and_yield(file))
      expect(file)
          .to(receive(:write)
              .with(<<-EOF
Key-Type: RSA
Key-Length: 2048
Subkey-Type: RSA
Subkey-Length: 2048
Name-Real: Cara Smith
Name-Email: cara.smith@example.com
Expire-Date: 0
EOF
))

      RubyGPG2::ParameterFile
          .new({
              owner_name: 'Cara Smith',
              owner_email: 'cara.smith@example.com',
          })
          .write_to(path)
    end
  end
end
