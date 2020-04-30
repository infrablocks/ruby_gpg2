require 'date'

module RubyGPG2
  class ColonRecord
    TYPES = {
        'pub' => :public_key,
        'crt' => :x509_certificate,
        'crs' => :x509_certificate_and_private_key,
        'sub' => :sub_key,
        'sec' => :secret_key,
        'ssb' => :secret_sub_key,
        'uid' => :user_id,
        'uat' => :user_attribute,
        'sig' => :signature,
        'rev' => :revocation_signature,
        'rvs' => :standalone_revocation_signature,
        'fpr' => :fingerprint,
        'pkd' => :public_key_data,
        'grp' => :key_grip,
        'rvk' => :revocation_key,
        'tfs' => :tofu_statistics,
        'tru' => :trust_database_information,
        'spk' => :signature_sub_packet,
        'cfg' => :configuration_data
    }

    TRUST_MODELS = {
        '0' => :classic,
        '1' => :pgp
    }

    VALIDITIES = {
        'o' => :unknown_new_key,
        'i' => :invalid,
        'd' => :disabled,
        'r' => :revoked,
        'e' => :expired,
        '-' => :unknown,
        'q' => :undefined,
        'n' => :never,
        'm' => :marginal,
        'f' => :full,
        'u' => :ultimate,
        'w' => :well_known_private,
        's' => :special
    }

    KEY_ALGORITHMS = {
        '1' => :rsa_encrypt_or_sign,
        '2' => :rsa_encrypt_only,
        '3' => :rsa_sign_only,
        '16' => :elgamal_encrypt_only,
        '17' => :dsa,
        '18' => :ecdh,
        '19' => :ecdsa,
    }

    TRUSTS = {
        '-' => :unknown,
        'n' => :never,
        'm' => :marginal,
        'f' => :full,
        'u' => :ultimate,
    }

    KEY_CAPABILITIES = {
        'e' => :encrypt,
        's' => :sign,
        'c' => :certify,
        'a' => :authenticate,
        'E' => :primary_encrypt,
        'S' => :primary_sign,
        'C' => :primary_certify,
        'A' => :primary_authenticate,
        '?' => :unknown
    }

    COMPLIANCE_MODES = {
        '8' => :rfc_4880bis,
        '23' => :de_vs,
        '6001' => :roca_screening_hit
    }

    def self.parse(record)
      fields = record.split(':', 22)
      type = type(fields[0])
      case type
      when :trust_database_information
        new(
            raw: record,
            type: type,
            trust_model: trust_model(fields[2]),
            creation_date: creation_date(fields[3]),
            expiration_date: expiration_date(fields[4]),
            new_key_signer_marginal_count:
                new_key_signer_marginal_count(fields[5]),
            new_key_signer_complete_count:
                new_key_signer_complete_count(fields[6]),
            maximum_certificate_chain_depth:
                maximum_certificate_chain_depth(fields[7]))
      else
        new(
            raw: record,
            type: type,
            validity: validity(fields[1]),
            key_length: key_length(fields[2]),
            key_algorithm: key_algorithm(fields[3]),
            key_id: key_id(fields[4]),
            creation_date: creation_date(fields[5]),
            expiration_date: expiration_date(fields[6]),
            user_id_hash: user_id_hash(type, fields[7]),
            owner_trust: owner_trust(fields[8]),
            fingerprint: fingerprint(type, fields[9]),
            user_id: user_id(type, fields[9]),
            signature_class: signature_class(fields[10]),
            key_capabilities: key_capabilities(fields[11]),
            compliance_modes: compliance_modes(fields[17]),
            last_update: last_update(fields[18]),
            origin: origin(fields[19]))
      end
    end

    attr_reader(
        :raw,
        :type,
        :trust_model,
        :validity,
        :key_length,
        :key_algorithm,
        :key_id,
        :creation_date,
        :expiration_date,
        :user_id_hash,
        :owner_trust,
        :fingerprint,
        :user_id,
        :signature_class,
        :key_capabilities,
        :compliance_modes,
        :last_update,
        :origin,
        :new_key_signer_marginal_count,
        :new_key_signer_complete_count,
        :maximum_certificate_chain_depth)

    def initialize(opts)
      @raw = opts[:raw]
      @type = opts[:type]
      @trust_model = opts[:trust_model]
      @validity = opts[:validity]
      @key_length = opts[:key_length]
      @key_algorithm = opts[:key_algorithm]
      @key_id = opts[:key_id]
      @creation_date = opts[:creation_date]
      @expiration_date = opts[:expiration_date]
      @user_id_hash = opts[:user_id_hash]
      @owner_trust = opts[:owner_trust]
      @fingerprint = opts[:fingerprint]
      @user_id = opts[:user_id]
      @signature_class = opts[:signature_class]
      @key_capabilities = opts[:key_capabilities]
      @compliance_modes = opts[:compliance_modes]
      @last_update = opts[:last_update]
      @origin = opts[:origin]
      @new_key_signer_marginal_count = opts[:new_key_signer_marginal_count]
      @new_key_signer_complete_count = opts[:new_key_signer_complete_count]
      @maximum_certificate_chain_depth = opts[:maximum_certificate_chain_depth]
    end

    def ==(other)
      other.class == self.class && other.state == state
    end

    protected

    def state
      [
          @raw,
          @type,
          @trust_model,
          @validity,
          @key_length,
          @key_algorithm,
          @key_id,
          @creation_date,
          @expiration_date,
          @user_id_hash,
          @owner_trust,
          @fingerprint,
          @user_id,
          @signature_class,
          @key_capabilities,
          @compliance_modes,
          @last_update,
          @origin,
          @new_key_signer_marginal_count,
          @new_key_signer_complete_count,
          @maximum_certificate_chain_depth
      ]
    end

    private

    def self.type(value)
      TYPES[value]
    end

    def self.trust_model(value)
      TRUST_MODELS[value]
    end

    def self.validity(value)
      VALIDITIES[value]
    end

    def self.key_length(value)
      value =~ /\d+/ ? value.to_s.to_i : nil
    end

    def self.key_algorithm(value)
      KEY_ALGORITHMS[value]
    end

    def self.key_id(value)
      value =~ /.+/ ? value : nil
    end

    def self.creation_date(value)
      value =~ /\d+/ ? DateTime.strptime(value, '%s') : nil
    end

    def self.expiration_date(value)
      value =~ /\d+/ ? DateTime.strptime(value, '%s') : nil
    end

    def self.user_id_hash(type, value)
      type == :user_id ? value : nil
    end

    def self.owner_trust(value)
      TRUSTS[value]
    end

    def self.fingerprint(type, value)
      type == :fingerprint ? value : nil
    end

    def self.user_id(type, value)
      unless type == :fingerprint
        value =~ /.+/ ? value : nil
      end
    end

    def self.signature_class(value)
      value =~ /.+/ ? value : nil
    end

    def self.key_capabilities(value)
      value =~ /.+/ ? value.chars.map { |c| KEY_CAPABILITIES[c] } : nil
    end

    def self.compliance_modes(value)
      value =~ /.+/ ? value.split(' ').map { |m| COMPLIANCE_MODES[m] } : nil
    end

    def self.last_update(value)
      value =~ /\d+/ ? DateTime.strptime(value, '%s') : nil
    end

    def self.origin(value)
      value
    end

    def self.new_key_signer_marginal_count(value)
      value =~ /\d+/ ? value.to_i : nil
    end

    def self.new_key_signer_complete_count(value)
      value =~ /\d+/ ? value.to_i : nil
    end

    def self.maximum_certificate_chain_depth(value)
      value =~ /\d+/ ? value.to_i : nil
    end
  end
end
