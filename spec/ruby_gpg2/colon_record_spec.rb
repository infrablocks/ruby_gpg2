require 'spec_helper'
require 'date'

describe RubyGPG2::ColonRecord do
  context 'parsing' do
    context 'for example records' do
      it 'parses a public key record' do
        raw_colon_record =
            "pub:u:2048:1:1A16916844CE9D82:1333003000:::u:::scESC::::::23::0:"

        colon_record = RubyGPG2::ColonRecord.parse(raw_colon_record)

        expect(colon_record)
            .to(eq(RubyGPG2::ColonRecord.new(
                raw: 'pub:u:2048:1:1A16916844CE9D82:' +
                    '1333003000:::u:::scESC::::::23::0:',
                type: :public_key,
                validity: :ultimate,
                key_length: 2048,
                key_algorithm: :rsa_encrypt_or_sign,
                key_id: '1A16916844CE9D82',
                creation_date: DateTime.strptime('1333003000', '%s'),
                owner_trust: :ultimate,
                key_capabilities: [
                    :sign,
                    :certify,
                    :primary_encrypt,
                    :primary_sign,
                    :primary_certify
                ],
                compliance_modes: [:de_vs],
                origin: '0'
            )))
      end

      it 'parses a fingerprint record' do
        colon_record =
            "fpr:::::::::41D2606F66C3FF28874362B61A16916844CE9D82:"

        key_list_record = RubyGPG2::ColonRecord.parse(colon_record)

        expect(key_list_record)
            .to(eq(RubyGPG2::ColonRecord.new(
                raw: "fpr:::::::::41D2606F66C3FF28874362B61A16916844CE9D82:",
                type: :fingerprint,
                fingerprint: '41D2606F66C3FF28874362B61A16916844CE9D82')))
      end

      it 'parses a user ID record' do
        colon_record =
            "uid:u::::1333003000::6D9560936837E5AC5007524183B9F354E4F5308C" +
                "::Toby Clemson <tobyclemson@gmail.com>::::::::::0:"

        key_list_record = RubyGPG2::ColonRecord.parse(colon_record)

        expect(key_list_record)
            .to(eq(RubyGPG2::ColonRecord.new(
                raw: "uid:u::::1333003000::" +
                    "6D9560936837E5AC5007524183B9F354E4F5308C" +
                    "::Toby Clemson <tobyclemson@gmail.com>::::::::::0:",
                type: :user_id,
                validity: :ultimate,
                creation_date: DateTime.strptime('1333003000', '%s'),
                user_id_hash: '6D9560936837E5AC5007524183B9F354E4F5308C',
                user_id: 'Toby Clemson <tobyclemson@gmail.com>',
                origin: '0')))
      end

      it 'parses a sub key record' do
        colon_record =
            "sub:r:2048:1:5374249938E895F1:1433361866:1685649866:::::s::::::23:"

        key_list_record = RubyGPG2::ColonRecord.parse(colon_record)

        expect(key_list_record)
            .to(eq(RubyGPG2::ColonRecord.new(
                raw: "sub:r:2048:1:5374249938E895F1:" +
                    "1433361866:1685649866:::::s::::::23:",
                type: :sub_key,
                validity: :revoked,
                key_length: 2048,
                key_algorithm: :rsa_encrypt_or_sign,
                key_id: '5374249938E895F1',
                creation_date: DateTime.strptime('1433361866', '%s'),
                expiration_date: DateTime.strptime('1685649866', '%s'),
                key_capabilities: [:sign],
                compliance_modes: [:de_vs]
            )))
      end

      it 'parses a signature record' do
        colon_record =
            "sig:::1:1A16916844CE9D82:1333003000::::" +
                "Toby Clemson <tobyclemson@gmail.com>:13x:::::2:"

        key_list_record = RubyGPG2::ColonRecord.parse(colon_record)

        expect(key_list_record)
            .to(eq(RubyGPG2::ColonRecord.new(
                raw: "sig:::1:1A16916844CE9D82:1333003000::::" +
                    "Toby Clemson <tobyclemson@gmail.com>:13x:::::2:",
                type: :signature,
                key_algorithm: :rsa_encrypt_or_sign,
                key_id: '1A16916844CE9D82',
                creation_date: DateTime.strptime('1333003000', '%s'),
                user_id: 'Toby Clemson <tobyclemson@gmail.com>',
                signature_class: '13x',
                hash_algorithm: :sha_1
            )))
      end

      it 'parses a secret key record' do
        colon_record =
            "sec:u:2048:1:1A16916844CE9D82:1333003000:::u:::scESC:::+:::23::0:"

        key_list_record = RubyGPG2::ColonRecord.parse(colon_record)

        expect(key_list_record)
            .to(eq(RubyGPG2::ColonRecord.new(
                raw: "sec:u:2048:1:1A16916844CE9D82:" +
                    "1333003000:::u:::scESC:::+:::23::0:",
                type: :secret_key,
                validity: :ultimate,
                key_length: 2048,
                key_algorithm: :rsa_encrypt_or_sign,
                key_id: '1A16916844CE9D82',
                creation_date: DateTime.strptime('1333003000', '%s'),
                owner_trust: :ultimate,
                key_capabilities: [
                    :sign,
                    :certify,
                    :primary_encrypt,
                    :primary_sign,
                    :primary_certify
                ],
                serial_number: '+',
                compliance_modes: [:de_vs],
                origin: '0')))
      end

      it 'parses a key grip record' do
        colon_record =
            "grp:::::::::D911410A3892C4C391614343D873FCF6318E8B31:"

        key_list_record = RubyGPG2::ColonRecord.parse(colon_record)

        expect(key_list_record)
            .to(eq(RubyGPG2::ColonRecord.new(
                raw: "grp:::::::::D911410A3892C4C391614343D873FCF6318E8B31:",
                type: :key_grip,
                key_grip: 'D911410A3892C4C391614343D873FCF6318E8B31')))
      end

      it 'parses a secret subkey record' do
        colon_record =
            "ssb:u:2048:1:FD7CF2BF6B89D9EA:1333003000::::::e:::+:::23:"

        key_list_record = RubyGPG2::ColonRecord.parse(colon_record)

        expect(key_list_record)
            .to(eq(RubyGPG2::ColonRecord.new(
                raw: "ssb:u:2048:1:FD7CF2BF6B89D9EA:" +
                    "1333003000::::::e:::+:::23:",
                type: :secret_sub_key,
                validity: :ultimate,
                key_length: 2048,
                key_algorithm: :rsa_encrypt_or_sign,
                key_id: 'FD7CF2BF6B89D9EA',
                creation_date: DateTime.strptime('1333003000', '%s'),
                key_capabilities: [
                    :encrypt
                ],
                serial_number: '+',
                compliance_modes: [:de_vs])))
      end

      it 'parses a trust database information record' do
        colon_record = "tru::1:1588023210:1636807690:3:1:5"

        key_list_record = RubyGPG2::ColonRecord.parse(colon_record)

        expect(key_list_record)
            .to(eq(RubyGPG2::ColonRecord.new(
                raw: "tru::1:1588023210:1636807690:3:1:5",
                type: :trust_database_information,
                trust_model: :pgp,
                creation_date: DateTime.strptime('1588023210', '%s'),
                expiration_date: DateTime.strptime('1636807690', '%s'),
                new_key_signer_marginal_count: 3,
                new_key_signer_complete_count: 1,
                maximum_certificate_chain_depth: 5)))
      end
    end

    context 'for record types' do
      {
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
      }.each do |type_string, type|
        it "handles records of type #{type_string}" do
          colon_record = "#{type_string}::::::::::::::::::::"

          key_list_record = RubyGPG2::ColonRecord.parse(colon_record)

          expect(key_list_record.type).to(eq(type))
        end
      end
    end

    context 'for validity' do
      {
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
      }.each do |validity_string, validity|
        it "handles records with validity #{validity_string}" do
          colon_record = "pub:#{validity_string}:::::::::::::::::::"

          key_list_record = RubyGPG2::ColonRecord.parse(colon_record)

          expect(key_list_record.validity).to(eq(validity))
        end
      end
    end

    context 'for key algorithms' do
      {
          '1' => :rsa_encrypt_or_sign,
          '2' => :rsa_encrypt_only,
          '3' => :rsa_sign_only,
          '16' => :elgamal_encrypt_only,
          '17' => :dsa,
          '18' => :ecdh,
          '19' => :ecdsa,
      }.each do |algorithm_identifier, algorithm|
        it "handles records with algorithm #{algorithm_identifier}" do
          colon_record = "pub:::#{algorithm_identifier}:::::::::::::::::"

          key_list_record = RubyGPG2::ColonRecord.parse(colon_record)

          expect(key_list_record.key_algorithm).to(eq(algorithm))
        end
      end
    end

    context 'for owner trusts' do
      {
          '-' => :unknown,
          'n' => :never,
          'm' => :marginal,
          'f' => :full,
          'u' => :ultimate,
      }.each do |owner_trust_string, owner_trust|
        it "handles records with owner trust #{owner_trust_string}" do
          colon_record = "pub::::::::#{owner_trust_string}::::::::::::"

          key_list_record = RubyGPG2::ColonRecord.parse(colon_record)

          expect(key_list_record.owner_trust).to(eq(owner_trust))
        end
      end
    end

    context 'for key capabilities' do
      {
          'e' => :encrypt,
          's' => :sign,
          'c' => :certify,
          'a' => :authenticate,
          'E' => :primary_encrypt,
          'S' => :primary_sign,
          'C' => :primary_certify,
          'A' => :primary_authenticate,
          '?' => :unknown
      }.each do |key_capability_string, key_capability|
        it "handles records with key capability #{key_capability_string}" do
          colon_record = "pub:::::::::::#{key_capability_string}:::::::::"

          key_list_record = RubyGPG2::ColonRecord.parse(colon_record)

          expect(key_list_record.key_capabilities)
              .to(eq([key_capability]))
        end
      end
    end

    context 'for compliance modes' do
      {
          '8' => :rfc_4880bis,
          '23' => :de_vs,
          '6001' => :roca_screening_hit
      }.each do |compliance_mode_string, compliance_mode|
        it "handles records with compliance mode #{compliance_mode_string}" do
          colon_record = "pub:::::::::::::::::#{compliance_mode_string}:::"

          key_list_record = RubyGPG2::ColonRecord.parse(colon_record)

          expect(key_list_record.compliance_modes)
              .to(eq([compliance_mode]))
        end
      end
    end
  end

  context 'properties' do
    it 'uses the raw record from the provided options' do
      key_list_record = RubyGPG2::ColonRecord.new(
          raw: "pub:u:2048:1:1A16916844CE9D82:" +
              "1333003000:::u:::scESC::::::23::0:")

      expect(key_list_record.raw)
          .to(eq("pub:u:2048:1:1A16916844CE9D82:" +
              "1333003000:::u:::scESC::::::23::0:"))
    end

    it 'uses the type from the provided options' do
      key_list_record = RubyGPG2::ColonRecord.new(
          type: :public_key)

      expect(key_list_record.type)
          .to(eq(:public_key))
    end

    it 'uses the trust model from the provided options' do
      key_list_record = RubyGPG2::ColonRecord.new(
          trust_model: :classic)

      expect(key_list_record.trust_model)
          .to(eq(:classic))
    end

    it 'uses the validity from the provided options' do
      key_list_record = RubyGPG2::ColonRecord.new(
          validity: :ultimate)

      expect(key_list_record.validity)
          .to(eq(:ultimate))
    end

    it 'uses the key length from the provided options' do
      key_list_record = RubyGPG2::ColonRecord.new(
          key_length: 4096)

      expect(key_list_record.key_length)
          .to(eq(4096))
    end

    it 'uses the public key algorithm from the provided options' do
      key_list_record = RubyGPG2::ColonRecord.new(
          key_algorithm: :dsa)

      expect(key_list_record.key_algorithm)
          .to(eq(:dsa))
    end

    it 'uses the key ID from the provided options' do
      key_list_record = RubyGPG2::ColonRecord.new(
          key_id: '556917E7F246486D')

      expect(key_list_record.key_id)
          .to(eq('556917E7F246486D'))
    end

    it 'uses the creation date from the provided options' do
      key_list_record = RubyGPG2::ColonRecord.new(
          creation_date: DateTime.strptime('1648132006', '%s'))

      expect(key_list_record.creation_date)
          .to(eq(DateTime.strptime('1648132006', '%s')))
    end

    it 'uses the expiration date from the provided options' do
      key_list_record = RubyGPG2::ColonRecord.new(
          expiration_date: DateTime.strptime('1648132006', '%s'))

      expect(key_list_record.expiration_date)
          .to(eq(DateTime.strptime('1648132006', '%s')))
    end

    it 'uses the user ID hash from the provided options' do
      key_list_record = RubyGPG2::ColonRecord.new(
          user_id_hash: '5F001D63A30B3D9C95FED014376934D9DBAA6E5D')

      expect(key_list_record.user_id_hash)
          .to(eq('5F001D63A30B3D9C95FED014376934D9DBAA6E5D'))
    end

    it 'uses the owner trust from the provided options' do
      key_list_record = RubyGPG2::ColonRecord.new(
          owner_trust: :marginal)

      expect(key_list_record.owner_trust)
          .to(eq(:marginal))
    end

    it 'uses the fingerprint from the provided options' do
      key_list_record = RubyGPG2::ColonRecord.new(
          fingerprint: '41D2606F66C3FF28874362B61A16916844CE9D82')

      expect(key_list_record.fingerprint)
          .to(eq('41D2606F66C3FF28874362B61A16916844CE9D82'))
    end

    it 'uses the key grip from the provided options' do
      key_list_record = RubyGPG2::ColonRecord.new(
          key_grip: '41D2606F66C3FF28874362B61A16916844CE9D82')

      expect(key_list_record.key_grip)
          .to(eq('41D2606F66C3FF28874362B61A16916844CE9D82'))
    end

    it 'uses the user ID from the provided options' do
      key_list_record = RubyGPG2::ColonRecord.new(
          user_id: 'James Jones <james.jones@example.com>')

      expect(key_list_record.user_id)
          .to(eq('James Jones <james.jones@example.com>'))
    end

    it 'uses the signature class from the provided options' do
      key_list_record = RubyGPG2::ColonRecord.new(
          signature_class: '11x')

      expect(key_list_record.signature_class).to(eq('11x'))
    end

    it 'uses the key capabilities from the provided options' do
      key_list_record = RubyGPG2::ColonRecord.new(
          key_capabilities: [
              :encrypt
          ])

      expect(key_list_record.key_capabilities)
          .to(eq([:encrypt]))
    end

    it 'uses the serial number from the provided options' do
      key_list_record = RubyGPG2::ColonRecord.new(
          serial_number: '#')

      expect(key_list_record.serial_number).to(eq('#'))
    end

    it 'uses the compliance modes from the provided options' do
      key_list_record = RubyGPG2::ColonRecord.new(
          compliance_modes: [:rfc_4880bis])

      expect(key_list_record.compliance_modes)
          .to(eq([:rfc_4880bis]))
    end

    it 'uses the last updated from the provided options' do
      key_list_record = RubyGPG2::ColonRecord.new(
          last_update: DateTime.strptime('1648132006', '%s'))

      expect(key_list_record.last_update)
          .to(eq(DateTime.strptime('1648132006', '%s')))
    end

    it 'uses the origin from the provided options' do
      key_list_record = RubyGPG2::ColonRecord.new(
          origin: '1')

      expect(key_list_record.origin)
          .to(eq('1'))
    end

    it 'uses the new key signer marginal count from the provided options' do
      key_list_record = RubyGPG2::ColonRecord.new(
          new_key_signer_marginal_count: 4)

      expect(key_list_record.new_key_signer_marginal_count)
          .to(eq(4))
    end

    it 'uses the new key signer complete count from the provided options' do
      key_list_record = RubyGPG2::ColonRecord.new(
          new_key_signer_complete_count: 2)

      expect(key_list_record.new_key_signer_complete_count)
          .to(eq(2))
    end

    it 'uses the maximum certificate chain depth from the provided options' do
      key_list_record = RubyGPG2::ColonRecord.new(
          maximum_certificate_chain_depth: 5)

      expect(key_list_record.maximum_certificate_chain_depth)
          .to(eq(5))
    end
  end

  context 'user ID methods' do
    context 'user_id_record?' do
      it 'returns true when record is a user_id' do
        colon_record = RubyGPG2::ColonRecord.new(
            raw: "uid:u::::1333003000::" +
                "6D9560936837E5AC5007524183B9F354E4F5308C" +
                "::Toby Clemson <tobyclemson@gmail.com>::::::::::0:",
            type: :user_id,
            validity: :ultimate,
            creation_date: DateTime.strptime('1333003000', '%s'),
            user_id_hash: '6D9560936837E5AC5007524183B9F354E4F5308C',
            user_id: 'Toby Clemson <tobyclemson@gmail.com>',
            origin: '0')

        expect(colon_record.user_id_record?).to(be(true))
      end

      it 'returns false when record is not a user_id' do
        colon_record = RubyGPG2::ColonRecord.new(
            raw: 'pub:u:2048:1:1A16916844CE9D82:' +
                '1333003000:::u:::scESC::::::23::0:',
            type: :public_key,
            validity: :ultimate,
            key_length: 2048,
            key_algorithm: :rsa_encrypt_or_sign,
            key_id: '1A16916844CE9D82',
            creation_date: DateTime.strptime('1333003000', '%s'),
            owner_trust: :ultimate,
            key_capabilities: [
                :sign,
                :certify,
                :primary_encrypt,
                :primary_sign,
                :primary_certify
            ],
            compliance_modes: [:de_vs],
            origin: '0')

        expect(colon_record.user_id_record?).to(be(false))
      end
    end

    context 'user_name' do
      it 'extracts the user name from the user id when present' do
        colon_record = RubyGPG2::ColonRecord.new(
            raw: "uid:u::::1333003000::" +
                "6D9560936837E5AC5007524183B9F354E4F5308C" +
                "::Toby Clemson <tobyclemson@gmail.com>::::::::::0:",
            type: :user_id,
            validity: :ultimate,
            creation_date: DateTime.strptime('1333003000', '%s'),
            user_id_hash: '6D9560936837E5AC5007524183B9F354E4F5308C',
            user_id: 'Toby Clemson <tobyclemson@gmail.com>',
            origin: '0')

        expect(colon_record.user_name).to(eq('Toby Clemson'))
      end

      it 'return nil when user id is missing' do
        colon_record = RubyGPG2::ColonRecord.new(
            raw: 'pub:u:2048:1:1A16916844CE9D82:' +
                '1333003000:::u:::scESC::::::23::0:',
            type: :public_key,
            validity: :ultimate,
            key_length: 2048,
            key_algorithm: :rsa_encrypt_or_sign,
            key_id: '1A16916844CE9D82',
            creation_date: DateTime.strptime('1333003000', '%s'),
            owner_trust: :ultimate,
            key_capabilities: [
                :sign,
                :certify,
                :primary_encrypt,
                :primary_sign,
                :primary_certify
            ],
            compliance_modes: [:de_vs],
            origin: '0')

        expect(colon_record.user_name).to(be_nil)
      end
    end

    context 'user_comment' do
      it 'extracts the user comment from the user id when present' do
        colon_record = RubyGPG2::ColonRecord.new(
            raw: "uid:u::::1333003000::" +
                "6D9560936837E5AC5007524183B9F354E4F5308C" +
                "::Toby Clemson (Personal) <tobyclemson@gmail.com>::::::::::0:",
            type: :user_id,
            validity: :ultimate,
            creation_date: DateTime.strptime('1333003000', '%s'),
            user_id_hash: '6D9560936837E5AC5007524183B9F354E4F5308C',
            user_id: 'Toby Clemson (Personal) <tobyclemson@gmail.com>',
            origin: '0')

        expect(colon_record.user_comment).to(eq('Personal'))
      end

      it 'returns nil when the user id contains no comment' do
        colon_record = RubyGPG2::ColonRecord.new(
            raw: "uid:u::::1333003000::" +
                "6D9560936837E5AC5007524183B9F354E4F5308C" +
                "::Toby Clemson <tobyclemson@gmail.com>::::::::::0:",
            type: :user_id,
            validity: :ultimate,
            creation_date: DateTime.strptime('1333003000', '%s'),
            user_id_hash: '6D9560936837E5AC5007524183B9F354E4F5308C',
            user_id: 'Toby Clemson <tobyclemson@gmail.com>',
            origin: '0')

        expect(colon_record.user_comment).to(be_nil)
      end

      it 'return nil when user id is missing' do
        colon_record = RubyGPG2::ColonRecord.new(
            raw: 'pub:u:2048:1:1A16916844CE9D82:' +
                '1333003000:::u:::scESC::::::23::0:',
            type: :public_key,
            validity: :ultimate,
            key_length: 2048,
            key_algorithm: :rsa_encrypt_or_sign,
            key_id: '1A16916844CE9D82',
            creation_date: DateTime.strptime('1333003000', '%s'),
            owner_trust: :ultimate,
            key_capabilities: [
                :sign,
                :certify,
                :primary_encrypt,
                :primary_sign,
                :primary_certify
            ],
            compliance_modes: [:de_vs],
            origin: '0')

        expect(colon_record.user_comment).to(be_nil)
      end
    end

    context 'user_email' do
      it 'extracts the user email from the user id when present' do
        colon_record = RubyGPG2::ColonRecord.new(
            raw: "uid:u::::1333003000::" +
                "6D9560936837E5AC5007524183B9F354E4F5308C" +
                "::Toby Clemson <tobyclemson@gmail.com>::::::::::0:",
            type: :user_id,
            validity: :ultimate,
            creation_date: DateTime.strptime('1333003000', '%s'),
            user_id_hash: '6D9560936837E5AC5007524183B9F354E4F5308C',
            user_id: 'Toby Clemson <tobyclemson@gmail.com>',
            origin: '0')

        expect(colon_record.user_email).to(eq('tobyclemson@gmail.com'))
      end

      it 'return nil when user id is missing' do
        colon_record = RubyGPG2::ColonRecord.new(
            raw: 'pub:u:2048:1:1A16916844CE9D82:' +
                '1333003000:::u:::scESC::::::23::0:',
            type: :public_key,
            validity: :ultimate,
            key_length: 2048,
            key_algorithm: :rsa_encrypt_or_sign,
            key_id: '1A16916844CE9D82',
            creation_date: DateTime.strptime('1333003000', '%s'),
            owner_trust: :ultimate,
            key_capabilities: [
                :sign,
                :certify,
                :primary_encrypt,
                :primary_sign,
                :primary_certify
            ],
            compliance_modes: [:de_vs],
            origin: '0')

        expect(colon_record.user_email).to(be_nil)
      end
    end
  end

  context 'equality' do
    it 'is equal when all properties are equal' do
      key_list_record_1 = build_record
      key_list_record_2 = build_record

      expect(key_list_record_1)
          .to(eq(key_list_record_2))
    end

    it 'is not equal if type is different' do
      key_list_record_1 = build_record(type: :public_key)
      key_list_record_2 = build_record(type: :secondary_key)

      expect(key_list_record_1)
          .not_to(eq(key_list_record_2))
    end

    it 'is not equal if trust model is different' do
      key_list_record_1 = build_record(trust_model: :classic)
      key_list_record_2 = build_record(trust_model: :pgp)

      expect(key_list_record_1)
          .not_to(eq(key_list_record_2))
    end

    it 'is not equal if validity is different' do
      key_list_record_1 = build_record(validity: :ultimate)
      key_list_record_2 = build_record(validity: :revoked)

      expect(key_list_record_1)
          .not_to(eq(key_list_record_2))
    end

    it 'is not equal if key length is different' do
      key_list_record_1 = build_record(key_length: 1024)
      key_list_record_2 = build_record(key_length: 2048)

      expect(key_list_record_1)
          .not_to(eq(key_list_record_2))
    end

    it 'is not equal if public key algorithm is different' do
      key_list_record_1 = build_record(
          key_algorithm: :rsa_encrypt_or_sign)
      key_list_record_2 = build_record(
          key_algorithm: :dsa)

      expect(key_list_record_1)
          .not_to(eq(key_list_record_2))
    end

    it 'is not equal if key ID is different' do
      key_list_record_1 = build_record(
          key_id: '1A16916844CE9D82')
      key_list_record_2 = build_record(
          key_id: 'E58AC941787A5130')

      expect(key_list_record_1)
          .not_to(eq(key_list_record_2))
    end

    it 'is not equal if creation date is different' do
      key_list_record_1 = build_record(
          creation_date: DateTime.strptime('1333003000', '%s'))
      key_list_record_2 = build_record(
          creation_date: DateTime.strptime('1387223000', '%s'))

      expect(key_list_record_1)
          .not_to(eq(key_list_record_2))
    end

    it 'is not equal if expiration date is different' do
      key_list_record_1 = build_record(
          expiration_date: DateTime.strptime('1333003000', '%s'))
      key_list_record_2 = build_record(
          expiration_date: DateTime.strptime('1387223000', '%s'))

      expect(key_list_record_1)
          .not_to(eq(key_list_record_2))
    end

    it 'is not equal if user ID hash is different' do
      key_list_record_1 = build_record(
          user_id_hash: '6D9560936837E5AC5007524183B9F354E4F5308C')
      key_list_record_2 = build_record(
          user_id_hash: '5F001D63A30B3D9C95FED014376934D9DBAA6E5D')

      expect(key_list_record_1)
          .not_to(eq(key_list_record_2))
    end

    it 'is not equal if owner trust is different' do
      key_list_record_1 = build_record(
          owner_trust: :ultimate)
      key_list_record_2 = build_record(
          owner_trust: :marginal)

      expect(key_list_record_1)
          .not_to(eq(key_list_record_2))
    end

    it 'is not equal if fingerprint is different' do
      key_list_record_1 = build_record(
          fingerprint: '41D2606F66C3FF28874362B61A16916844CE9D82')
      key_list_record_2 = build_record(
          fingerprint: '380A79B836ECDE7D65981ECF9A160A601DF21B4B')

      expect(key_list_record_1)
          .not_to(eq(key_list_record_2))
    end

    it 'is not equal if key grip is different' do
      key_list_record_1 = build_record(
          key_grip: '41D2606F66C3FF28874362B61A16916844CE9D82')
      key_list_record_2 = build_record(
          key_grip: '380A79B836ECDE7D65981ECF9A160A601DF21B4B')

      expect(key_list_record_1)
          .not_to(eq(key_list_record_2))
    end

    it 'is not equal if user ID is different' do
      key_list_record_1 = build_record(
          user_id: 'James Jones <james.jones@example.com>')
      key_list_record_2 = build_record(
          user_id: 'Amanda Reeves <amanda.reeves@example.com>')

      expect(key_list_record_1)
          .not_to(eq(key_list_record_2))
    end

    it 'is not equal if signature class is different' do
      key_list_record_1 = build_record(
          signature_class: '10x')
      key_list_record_2 = build_record(
          signature_class: '13x')

      expect(key_list_record_1)
          .not_to(eq(key_list_record_2))
    end

    it 'is not equal if key capabilities are different' do
      key_list_record_1 = build_record(
          key_capabilities: [
              :sign,
              :certify,
              :encrypt,
              :primary_sign,
              :primary_certify
          ])
      key_list_record_2 = build_record(
          key_capabilities: [
              :encrypt,
          ])

      expect(key_list_record_1)
          .not_to(eq(key_list_record_2))
    end

    it 'is not equal if compliance modes are different' do
      key_list_record_1 = build_record(
          compliance_modes: [:de_vs])
      key_list_record_2 = build_record(
          compliance_modes: [:de_vs, :rfc_4880bis])

      expect(key_list_record_1)
          .not_to(eq(key_list_record_2))
    end

    it 'is not equal if serial numbers are different' do
      key_list_record_1 = build_record(
          serial_number: '+')
      key_list_record_2 = build_record(
          serial_number: '#')

      expect(key_list_record_1)
          .not_to(eq(key_list_record_2))
    end

    it 'is not equal if last update is different' do
      key_list_record_1 = build_record(
          last_update: DateTime.strptime('1333003000', '%s'))
      key_list_record_2 = build_record(
          last_update: :unknown)

      expect(key_list_record_1)
          .not_to(eq(key_list_record_2))
    end

    it 'is not equal if origin is different' do
      key_list_record_1 = build_record(
          origin: '0')
      key_list_record_2 = build_record(
          origin: '1')

      expect(key_list_record_1)
          .not_to(eq(key_list_record_2))
    end

    it 'is not equal if new key signer marginal count is different' do
      key_list_record_1 = build_record(
          new_key_signer_marginal_count: 4)
      key_list_record_2 = build_record(
          new_key_signer_marginal_count: 3)

      expect(key_list_record_1)
          .not_to(eq(key_list_record_2))
    end

    it 'is not equal if new key signer complete count is different' do
      key_list_record_1 = build_record(
          new_key_signer_complete_count: 2)
      key_list_record_2 = build_record(
          new_key_signer_complete_count: 3)

      expect(key_list_record_1)
          .not_to(eq(key_list_record_2))
    end

    it 'is not equal if maximum certificate chain depth is different' do
      key_list_record_1 = build_record(
          maximum_certificate_chain_depth: 5)
      key_list_record_2 = build_record(
          maximum_certificate_chain_depth: 4)

      expect(key_list_record_1)
          .not_to(eq(key_list_record_2))
    end
  end

  def build_record(overrides = {})
    RubyGPG2::ColonRecord.new({
        raw: 'pub:u:2048:1:1A16916844CE9D82:' +
            '1333003000:::u:::scESC::::::23::0:',
        type: :public_key,
        validity: :ultimate,
        key_length: 2048,
        key_algorithm: :rsa_encrypt_or_sign,
        key_id: '1A16916844CE9D82',
        creation_date: DateTime.strptime('1333003000', '%s'),
        owner_trust: :ultimate,
        key_capabilities: [
            :sign,
            :certify,
            :primary_encrypt,
            :primary_sign,
            :primary_certify
        ],
        compliance_modes: [:de_vs],
        last_update: :unknown,
        origin: '0'
    }.merge(overrides))
  end
end
