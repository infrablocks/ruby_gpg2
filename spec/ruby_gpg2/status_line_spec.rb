require 'spec_helper'

describe RubyGPG2::StatusLine do
  context 'parsing' do
    context 'for example lines' do
      it 'parses a key created line' do
        raw_status_line =
            "[GNUPG:] KEY_CREATED B E0637AE8F9059A371245DB3844528004E095862C"

        status_line = RubyGPG2::StatusLine.parse(raw_status_line)

        expect(status_line)
            .to(eq(RubyGPG2::StatusLines::KeyCreated.new(
                raw: raw_status_line,
                key_type: :primary_and_subkey,
                key_fingerprint: 'E0637AE8F9059A371245DB3844528004E095862C')))
      end

      it 'parses a key considered line' do
        raw_status_line =
            "[GNUPG:] KEY_CONSIDERED E0637AE8F9059A371245DB3844528004E095862C 0"

        status_line = RubyGPG2::StatusLine.parse(raw_status_line)

        expect(status_line)
            .to(eq(RubyGPG2::StatusLines::KeyConsidered.new(
                raw: raw_status_line,
                key_fingerprint: 'E0637AE8F9059A371245DB3844528004E095862C',
                flags: [])))
      end

      it 'parses an imported line' do
        raw_status_line =
            "[GNUPG:] IMPORTED 582D74F22F5601F8 Lara Dukes <ldukes@example.com>"

        status_line = RubyGPG2::StatusLine.parse(raw_status_line)

        expect(status_line)
            .to(eq(RubyGPG2::StatusLines::Imported.new(
                raw: raw_status_line,
                key_id: '582D74F22F5601F8',
                user_id: 'Lara Dukes <ldukes@example.com>')))
      end

      it 'parses an import ok line' do
        raw_status_line =
            "[GNUPG:] IMPORT_OK 1 A65C6366D55F0BA7719EE38F582D74F22F5601F8"

        status_line = RubyGPG2::StatusLine.parse(raw_status_line)

        expect(status_line)
            .to(eq(RubyGPG2::StatusLines::ImportOK.new(
                raw: raw_status_line,
                reasons: [:new_key],
                key_fingerprint: 'A65C6366D55F0BA7719EE38F582D74F22F5601F8')))
      end

      it 'parses an import ok line' do
        raw_status_line =
            "[GNUPG:] IMPORT_PROBLEM 2 A65C6366D55F0BA7719EE38F582D74F22F5601F8"

        status_line = RubyGPG2::StatusLine.parse(raw_status_line)

        expect(status_line)
            .to(eq(RubyGPG2::StatusLines::ImportProblem.new(
                raw: raw_status_line,
                reason: :issuer_certificate_missing,
                key_fingerprint: 'A65C6366D55F0BA7719EE38F582D74F22F5601F8')))
      end
    end

    it 'parses unimplemented types' do
      raw_status_line = "[GNUPG:] KEYREVOKED"

      status_line = RubyGPG2::StatusLine.parse(raw_status_line)

      expect(status_line)
          .to(eq(RubyGPG2::StatusLines::Unimplemented.new(
              raw: raw_status_line)))
    end
  end
end
