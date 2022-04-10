# frozen_string_literal: true

require 'spec_helper'

RSpec.describe RubyGPG2 do
  it 'has a version number' do
    expect(RubyGPG2::VERSION).not_to be_nil
  end
end
