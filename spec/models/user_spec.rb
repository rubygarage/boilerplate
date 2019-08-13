# frozen_string_literal: true

RSpec.describe User, type: :model do
  describe 'model fields' do
    it { is_expected.to have_db_column(:name).of_type(:string) }
    it { is_expected.to have_db_column(:created_at).of_type(:datetime) }
    it { is_expected.to have_db_column(:updated_at).of_type(:datetime) }
  end

  describe 'model relations' do
    it { is_expected.to belong_to(:account) }
  end
end
