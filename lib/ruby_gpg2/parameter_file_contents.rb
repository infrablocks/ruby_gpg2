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
        :passphrase)

    def initialize(opts)
      @key_type = opts.fetch(:key_type, 'RSA')
      @key_length = opts.fetch(:key_length,
          (@key_type.to_s == 'default' ? nil : 2048))
      @subkey_type = opts.fetch(:subkey_type, 'RSA')
      @subkey_length = opts.fetch(:subkey_length,
          ((@subkey_type.nil? || @subkey_type.to_s == 'default') ? nil : 2048))
      @owner_name = opts.fetch(:owner_name, nil)
      @owner_email = opts.fetch(:owner_email, nil)
      @owner_comment = opts.fetch(:owner_comment, nil)
      @expiry = opts.fetch(:expiry, :never)
      @passphrase = opts.fetch(:passphrase, nil)

      owner_name_present = !@owner_name.nil?
      owner_email_present = !@owner_email.nil?
      missing_count = [
          owner_name_present,
          owner_email_present
      ].count(false)
      missing_names = [
          owner_name_present ? nil : :owner_name,
          owner_email_present ? nil : :owner_email
      ].compact

      unless missing_count == 0
        raise RuntimeError.new(
            "Missing required parameter#{missing_count > 1 ? 's' : ''}: " +
                "#{missing_names}.")
      end
    end

    def write_to(path)
      File.open(path, 'w') do |f|
        f.write(to_s)
      end
    end

    def in_temp_file(tmpdir = nil)
      Tempfile.create('parameter-file', tmpdir) do |f|
        f.write(to_s)
        f.flush
        yield f
      end
    end

    def to_s
      [
          parm("Key-Type", key_type),
          parm("Key-Length", key_length),
          parm("Subkey-Type", subkey_type),
          parm('Subkey-Length', subkey_length),
          parm('Name-Real', owner_name),
          parm('Name-Comment', owner_comment),
          parm('Name-Email', owner_email),
          parm('Expire-Date',
              expiry == :never ? 0 : expiry),
          parm('Passphrase', passphrase),
      ].compact.join("\n") + "\n"
    end

    private

    def parm(name, value)
      value ? "#{name}: #{value}" : nil
    end
  end
end
