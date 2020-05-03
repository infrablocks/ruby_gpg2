require 'spec_helper'
require 'date'

describe RubyGPG2::StatusOutput do
  context 'equality' do
    it 'is equal if it has identical lines' do
      first = RubyGPG2::StatusOutput.new([
          RubyGPG2::StatusLine.parse(
              "[GNUPG:] KEY_CREATED B " +
                  "E0637AE8F9059A371245DB3844528004E095862C")
      ])
      second = RubyGPG2::StatusOutput.new([
          RubyGPG2::StatusLine.parse(
              "[GNUPG:] KEY_CREATED B " +
                  "E0637AE8F9059A371245DB3844528004E095862C")
      ])

      expect(first).to(eq(second))
    end

    it 'is not equal if it has different lines' do
      first = RubyGPG2::StatusOutput.new([
          RubyGPG2::StatusLine.parse(
              "[GNUPG:] KEY_CREATED B " +
                  "E0637AE8F9059A371245DB3844528004E095862C")
      ])
      second = RubyGPG2::StatusOutput.new([
          RubyGPG2::StatusLine.parse(
              "[GNUPG:] KEY_CREATED P " +
                  "883EF3739A2A0496D0290E5CD6741A3E016D4842 ABCD")
      ])

      expect(first).not_to(eq(second))
    end
  end
end
