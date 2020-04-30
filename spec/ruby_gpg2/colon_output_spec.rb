require 'spec_helper'
require 'date'

describe RubyGPG2::ColonOutput do
  it 'is equal if it has identical records' do
    first = RubyGPG2::ColonOutput.new([
        RubyGPG2::ColonRecord.parse(
            "pub:u:2048:1:1A16916844CE9D82:" +
                "1333003000:::u:::scESC::::::23::0:")
    ])
    second = RubyGPG2::ColonOutput.new([
        RubyGPG2::ColonRecord.parse(
            "pub:u:2048:1:1A16916844CE9D82:" +
                "1333003000:::u:::scESC::::::23::0:")
    ])

    expect(first).to(eq(second))
  end

  it 'is not equal if it has different records' do
    first = RubyGPG2::ColonOutput.new([
        RubyGPG2::ColonRecord.parse(
            "pub:u:2048:1:1A16916844CE9D82:" +
                "1333003000:::u:::scESC::::::23::0:")
    ])
    second = RubyGPG2::ColonOutput.new([
        RubyGPG2::ColonRecord.parse(
            "pub:u:2048:1:71BF470703C2F2B0:" +
                "1462791132:::u:::scESC::::::23::0:")
    ])

    expect(first).not_to(eq(second))
  end
end
