# frozen_string_literal: true

require 'date'

module RubyGPG2
  # rubocop:disable Metrics/ClassLength
  class ColonRecord
    USER_ID_REGEX = /^(.*?) (?:\((.*)\) )?<(.*)>$/.freeze

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
    }.freeze

    TRUST_MODELS = {
      '0' => :classic,
      '1' => :pgp
    }.freeze

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
    }.freeze

    KEY_ALGORITHMS = {
      '1' => :rsa_encrypt_or_sign,
      '2' => :rsa_encrypt_only,
      '3' => :rsa_sign_only,
      '16' => :elgamal_encrypt_only,
      '17' => :dsa,
      '18' => :ecdh,
      '19' => :ecdsa
    }.freeze

    TRUSTS = {
      '-' => :unknown,
      'n' => :never,
      'm' => :marginal,
      'f' => :full,
      'u' => :ultimate
    }.freeze

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
    }.freeze

    COMPLIANCE_MODES = {
      '8' => :rfc_4880bis,
      '23' => :de_vs,
      '6001' => :roca_screening_hit
    }.freeze

    def self.parse(record)
      fields = record.split(':', 22)
      type = type(fields[0])
      if trust_base_record?(type)
        make_trust_base_record(record, type, fields)
      else
        make_standard_record(record, type, fields)
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
      :key_grip,
      :user_id,
      :signature_class,
      :key_capabilities,
      :serial_number,
      :compliance_modes,
      :last_update,
      :origin,
      :new_key_signer_marginal_count,
      :new_key_signer_complete_count,
      :maximum_certificate_chain_depth
    )

    # rubocop:disable Metrics/MethodLength
    # rubocop:disable Metrics/AbcSize
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
      @key_grip = opts[:key_grip]
      @user_id = opts[:user_id]
      @signature_class = opts[:signature_class]
      @key_capabilities = opts[:key_capabilities]
      @serial_number = opts[:serial_number]
      @compliance_modes = opts[:compliance_modes]
      @last_update = opts[:last_update]
      @origin = opts[:origin]
      @new_key_signer_marginal_count = opts[:new_key_signer_marginal_count]
      @new_key_signer_complete_count = opts[:new_key_signer_complete_count]
      @maximum_certificate_chain_depth = opts[:maximum_certificate_chain_depth]
    end
    # rubocop:enable Metrics/AbcSize
    # rubocop:enable Metrics/MethodLength

    def fingerprint_record?
      type == :fingerprint
    end

    def user_id_record?
      type == :user_id
    end

    def user_name
      match = user_id&.match(USER_ID_REGEX)
      return unless match

      match[1]
    end

    def user_comment
      match = user_id&.match(USER_ID_REGEX)
      return unless match

      match[2]
    end

    def user_email
      match = user_id&.match(USER_ID_REGEX)
      return unless match

      match[3]
    end

    def ==(other)
      other.class == self.class && other.state == state
    end

    protected

    # rubocop:disable Metrics/MethodLength
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
        @key_grip,
        @user_id,
        @signature_class,
        @key_capabilities,
        @serial_number,
        @compliance_modes,
        @last_update,
        @origin,
        @new_key_signer_marginal_count,
        @new_key_signer_complete_count,
        @maximum_certificate_chain_depth
      ]
    end
    # rubocop:enable Metrics/MethodLength

    class << self
      protected

      # rubocop:disable Metrics/MethodLength
      # rubocop:disable Metrics/AbcSize
      def make_standard_record(record, type, fields)
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
          key_grip: key_grip(type, fields[9]),
          user_id: user_id(type, fields[9]),
          signature_class: signature_class(fields[10]),
          key_capabilities: key_capabilities(fields[11]),
          serial_number: serial_number(fields[14]),
          compliance_modes: compliance_modes(fields[17]),
          last_update: last_update(fields[18]),
          origin: origin(fields[19])
        )
      end
      # rubocop:enable Metrics/AbcSize
      # rubocop:enable Metrics/MethodLength

      # rubocop:disable Metrics/MethodLength
      def make_trust_base_record(record, type, fields)
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
            maximum_certificate_chain_depth(fields[7])
        )
      end
      # rubocop:enable Metrics/MethodLength

      def trust_base_record?(type)
        type == :trust_database_information
      end

      def type(value)
        TYPES[value]
      end

      def trust_model(value)
        TRUST_MODELS[value]
      end

      def validity(value)
        VALIDITIES[value]
      end

      def key_length(value)
        value =~ /\d+/ ? value.to_s.to_i : nil
      end

      def key_algorithm(value)
        KEY_ALGORITHMS[value]
      end

      def key_id(value)
        value =~ /.+/ ? value : nil
      end

      def creation_date(value)
        value =~ /\d+/ ? DateTime.strptime(value, '%s') : nil
      end

      def expiration_date(value)
        value =~ /\d+/ ? DateTime.strptime(value, '%s') : nil
      end

      def user_id_hash(type, value)
        type == :user_id ? value : nil
      end

      def owner_trust(value)
        TRUSTS[value]
      end

      def fingerprint(type, value)
        type == :fingerprint ? value : nil
      end

      def key_grip(type, value)
        type == :key_grip ? value : nil
      end

      def user_id(type, value)
        return if %i[fingerprint key_grip].include?(type)

        value =~ /.+/ ? value : nil
      end

      def signature_class(value)
        value =~ /.+/ ? value : nil
      end

      def key_capabilities(value)
        value =~ /.+/ ? value.chars.map { |c| KEY_CAPABILITIES[c] } : nil
      end

      def serial_number(value)
        value =~ /.+/ ? value : nil
      end

      def compliance_modes(value)
        value =~ /.+/ ? value.split.map { |m| COMPLIANCE_MODES[m] } : nil
      end

      def last_update(value)
        value =~ /\d+/ ? DateTime.strptime(value, '%s') : nil
      end

      def origin(value)
        value
      end

      def new_key_signer_marginal_count(value)
        value =~ /\d+/ ? value.to_i : nil
      end

      def new_key_signer_complete_count(value)
        value =~ /\d+/ ? value.to_i : nil
      end

      def maximum_certificate_chain_depth(value)
        value =~ /\d+/ ? value.to_i : nil
      end
    end
  end
  # rubocop:enable Metrics/ClassLength
end
