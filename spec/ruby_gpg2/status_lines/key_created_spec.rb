# frozen_string_literal: true

require 'spec_helper'

describe RubyGPG2::StatusLines::KeyCreated do
  describe 'parsing' do
    describe 'key_types' do
      {
        'B' => :primary_and_subkey,
        'P' => :primary,
        'S' => :subkey
      }.each do |key_type_string, key_type|
        it "parses key type #{key_type_string}" do
          raw_status_line =
            "[GNUPG:] KEY_CREATED #{key_type_string} " \
            'E0637AE8F9059A371245DB3844528004E095862C'

          status_line = described_class.parse(raw_status_line)

          expect(status_line.key_type).to(eq(key_type))
        end
      end
    end

    it 'parses the handle when present' do
      raw_status_line =
        '[GNUPG:] KEY_CREATED P ' \
        'E0637AE8F9059A371245DB3844528004E095862C ABCD'

      status_line = described_class.parse(raw_status_line)

      expect(status_line.handle).to(eq('ABCD'))
    end
  end

  describe 'properties' do
    it 'uses the raw record from the provided options' do
      status_line = described_class.new(
        raw: '[GNUPG:] ' \
             'KEY_CREATED B E0637AE8F9059A371245DB3844528004E095862C'
      )

      expect(status_line.raw)
        .to(eq('[GNUPG:] ' \
               'KEY_CREATED B E0637AE8F9059A371245DB3844528004E095862C'))
    end

    it 'has type :key_created' do
      status_line = described_class.new({})

      expect(status_line.type).to(eq(:key_created))
    end

    it 'uses the key type from the provided options' do
      status_line = described_class.new(
        key_type: :primary_and_subkey
      )

      expect(status_line.key_type).to(eq(:primary_and_subkey))
    end

    it 'uses the key fingerprint from the provided options' do
      status_line = described_class.new(
        key_fingerprint: 'E0637AE8F9059A371245DB3844528004E095862C'
      )

      expect(status_line.key_fingerprint)
        .to(eq('E0637AE8F9059A371245DB3844528004E095862C'))
    end
  end

  describe 'equality' do
    it 'is equal when all properties are equal' do
      status_line1 = described_class.new(
        raw: '[GNUPG:] ' \
             'KEY_CREATED B 883EF3739A2A0496D0290E5CD6741A3E016D4842',
        key_type: :primary_and_subkey,
        key_fingerprint: '883EF3739A2A0496D0290E5CD6741A3E016D4842'
      )
      status_line2 = described_class.new(
        raw: '[GNUPG:] ' \
             'KEY_CREATED B 883EF3739A2A0496D0290E5CD6741A3E016D4842',
        key_type: :primary_and_subkey,
        key_fingerprint: '883EF3739A2A0496D0290E5CD6741A3E016D4842'
      )

      expect(status_line1).to(eq(status_line2))
    end

    it 'is not equal if key types are different' do
      status_line1 = described_class.new(
        raw: '[GNUPG:] ' \
             'KEY_CREATED B E0637AE8F9059A371245DB3844528004E095862C',
        key_type: :primary,
        key_fingerprint: 'E0637AE8F9059A371245DB3844528004E095862C'
      )
      status_line2 = described_class.new(
        raw: '[GNUPG:] ' \
             'KEY_CREATED B E0637AE8F9059A371245DB3844528004E095862C',
        key_type: :subkey,
        key_fingerprint: 'E0637AE8F9059A371245DB3844528004E095862C'
      )

      expect(status_line1).not_to(eq(status_line2))
    end
  end
end
