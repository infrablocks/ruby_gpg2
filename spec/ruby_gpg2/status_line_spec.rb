require 'spec_helper'

describe RubyGPG2::StatusLine do
  context 'parsing' do
    context 'for example lines' do
      it 'parses a key created line' do
        raw_status_line =
            "[GNUPG:] KEY_CREATED B E0637AE8F9059A371245DB3844528004E095862C"

        status_line = RubyGPG2::StatusLine.parse(raw_status_line)

        expect(status_line)
            .to(eq(RubyGPG2::StatusLine::KeyCreated.new(
                raw: raw_status_line,
                key_type: :primary_and_subkey,
                key_fingerprint: 'E0637AE8F9059A371245DB3844528004E095862C')))
      end

      it 'parses a key considered line' do
        raw_status_line =
            "[GNUPG:] KEY_CONSIDERED E0637AE8F9059A371245DB3844528004E095862C 0"

        status_line = RubyGPG2::StatusLine.parse(raw_status_line)

        expect(status_line)
            .to(eq(RubyGPG2::StatusLine::KeyConsidered.new(
                raw: raw_status_line,
                key_fingerprint: 'E0637AE8F9059A371245DB3844528004E095862C',
                flags: [])))
      end
    end

    it 'parses unimplemented types' do
      raw_status_line = "[GNUPG:] KEYREVOKED"

      status_line = RubyGPG2::StatusLine.parse(raw_status_line)

      expect(status_line)
          .to(eq(RubyGPG2::StatusLine::Unimplemented.new(
              raw: raw_status_line)))
    end
  end
end

describe RubyGPG2::StatusLine::KeyCreated do
  context 'parsing' do
    context 'key_types' do
      {
          'B' => :primary_and_subkey,
          'P' => :primary,
          'S' => :subkey
      }.each do |key_type_string, key_type|
        it "parses key type #{key_type_string}" do
          raw_status_line =
              "[GNUPG:] KEY_CREATED #{key_type_string} " +
                  "E0637AE8F9059A371245DB3844528004E095862C"

          status_line = RubyGPG2::StatusLine::KeyCreated.parse(raw_status_line)

          expect(status_line.key_type).to(eq(key_type))
        end
      end
    end

    it 'parses the handle when present' do
      raw_status_line =
          '[GNUPG:] KEY_CREATED P ' +
              'E0637AE8F9059A371245DB3844528004E095862C ABCD'

      status_line = RubyGPG2::StatusLine::KeyCreated.parse(raw_status_line)

      expect(status_line.handle).to(eq('ABCD'))
    end
  end

  context 'properties' do
    it 'uses the raw record from the provided options' do
      status_line = RubyGPG2::StatusLine::KeyCreated.new(
          raw: "[GNUPG:] " +
              "KEY_CREATED B E0637AE8F9059A371245DB3844528004E095862C")

      expect(status_line.raw)
          .to(eq("[GNUPG:] " +
              "KEY_CREATED B E0637AE8F9059A371245DB3844528004E095862C"))
    end

    it 'has type :key_created' do
      status_line = RubyGPG2::StatusLine::KeyCreated.new({})

      expect(status_line.type).to(eq(:key_created))
    end

    it 'uses the key type from the provided options' do
      status_line = RubyGPG2::StatusLine::KeyCreated.new(
          key_type: :primary_and_subkey)

      expect(status_line.key_type).to(eq(:primary_and_subkey))
    end

    it 'uses the key fingerprint from the provided options' do
      status_line = RubyGPG2::StatusLine::KeyCreated.new(
          key_fingerprint: 'E0637AE8F9059A371245DB3844528004E095862C')

      expect(status_line.key_fingerprint)
          .to(eq('E0637AE8F9059A371245DB3844528004E095862C'))
    end
  end

  context 'equality' do
    it 'is equal when all properties are equal' do
      status_line_1 = RubyGPG2::StatusLine::KeyCreated.new(
          raw: "[GNUPG:] " +
              "KEY_CREATED B 883EF3739A2A0496D0290E5CD6741A3E016D4842",
          key_type: :primary_and_subkey,
          key_fingerprint: '883EF3739A2A0496D0290E5CD6741A3E016D4842')
      status_line_2 = RubyGPG2::StatusLine::KeyCreated.new(
          raw: "[GNUPG:] " +
              "KEY_CREATED B 883EF3739A2A0496D0290E5CD6741A3E016D4842",
          key_type: :primary_and_subkey,
          key_fingerprint: '883EF3739A2A0496D0290E5CD6741A3E016D4842')

      expect(status_line_1).to(eq(status_line_2))
    end

    it 'is not equal if key types are different' do
      status_line_1 = RubyGPG2::StatusLine::KeyCreated.new(
          raw: "[GNUPG:] " +
              "KEY_CREATED B E0637AE8F9059A371245DB3844528004E095862C",
          key_type: :primary,
          key_fingerprint: 'E0637AE8F9059A371245DB3844528004E095862C')
      status_line_2 = RubyGPG2::StatusLine::KeyCreated.new(
          raw: "[GNUPG:] " +
              "KEY_CREATED B E0637AE8F9059A371245DB3844528004E095862C",
          key_type: :subkey,
          key_fingerprint: 'E0637AE8F9059A371245DB3844528004E095862C')

      expect(status_line_1).not_to(eq(status_line_2))
    end
  end
end
