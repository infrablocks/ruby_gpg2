# frozen_string_literal: true

require 'tempfile'

module RubyGPG2
  class ParameterFileContents
    attr_reader(
      :key_type,
      :key_length,
      :subkey_type,
      :subkey_length,
      :owner_name,
      :owner_email,
      :owner_comment,
      :expiry,
      :passphrase
    )

    def initialize(opts)
      @key_type = resolve_key_type(opts)
      @key_length = resolve_key_length(opts, @key_type)
      @subkey_type = resolve_subkey_type(opts)
      @subkey_length = resolve_subkey_length(opts, @subkey_type)
      @owner_name = resolve_owner_name(opts)
      @owner_email = resolve_owner_email(opts)
      @owner_comment = resolve_owner_comment(opts)
      @expiry = resolve_expiry(opts)
      @passphrase = resolve_passphrase(opts)

      assert_required_parameters_present
    end

    def expiry_date
      expiry == :never ? 0 : expiry
    end

    def write_to(path)
      File.open(path, 'w') { |f| f.write(to_s) }
    end

    def in_temp_file(tmpdir = nil)
      Tempfile.create('parameter-file', tmpdir) do |f|
        f.write(to_s)
        f.flush
        yield f
      end
    end

    def to_s
      "#{to_parms.compact.join("\n")}\n"
    end

    private

    def assert_required_parameters_present
      owner_name_present = !@owner_name.nil?
      owner_email_present = !@owner_email.nil?
      missing_count = [owner_name_present, owner_email_present].count(false)
      missing_names =
        [to_error_code(owner_name_present, :owner_name),
         to_error_code(owner_email_present, :owner_email)].compact

      return if missing_count.zero?

      raise "Missing required parameter#{missing_count > 1 ? 's' : ''}: " \
            "#{missing_names}."
    end

    def to_error_code(present, code)
      present ? nil : code
    end

    def resolve_key_type(opts)
      opts.fetch(:key_type, 'RSA')
    end

    def resolve_key_length(opts, key_type)
      opts.fetch(
        :key_length, (key_type.to_s == 'default' ? nil : 2048)
      )
    end

    def resolve_subkey_type(opts)
      opts.fetch(:subkey_type, 'RSA')
    end

    def resolve_subkey_length(opts, subkey_type)
      opts.fetch(
        :subkey_length,
        (subkey_type.nil? || subkey_type.to_s == 'default' ? nil : 2048)
      )
    end

    def resolve_owner_name(opts)
      opts.fetch(:owner_name, nil)
    end

    def resolve_owner_email(opts)
      opts.fetch(:owner_email, nil)
    end

    def resolve_owner_comment(opts)
      opts.fetch(:owner_comment, nil)
    end

    def resolve_expiry(opts)
      opts.fetch(:expiry, :never)
    end

    def resolve_passphrase(opts)
      opts.fetch(:passphrase, nil)
    end

    # rubocop:disable Metrics/AbcSize
    def to_parms
      [parm('Key-Type', key_type),
       parm('Key-Length', key_length),
       parm('Subkey-Type', subkey_type),
       parm('Subkey-Length', subkey_length),
       parm('Name-Real', owner_name),
       parm('Name-Comment', owner_comment),
       parm('Name-Email', owner_email),
       parm('Expire-Date', expiry_date),
       parm('Passphrase', passphrase)]
    end
    # rubocop:enable Metrics/AbcSize

    def parm(name, value)
      value ? "#{name}: #{value}" : nil
    end
  end
end
