# frozen_string_literal: true

RSpec.describe ApplicationRecord, type: :model do
  it { expect(described_class).to be < ActiveRecord::Base }
  it { expect(described_class.abstract_class).to be(true) }
end
