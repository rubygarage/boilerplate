# frozen_string_literal: true

RSpec.describe Setting, type: :model do
  it { is_expected.to have_db_column(:key).of_type(:string) }
  it { is_expected.to have_db_column(:value).of_type(:string).with_options(null: false) }
end
