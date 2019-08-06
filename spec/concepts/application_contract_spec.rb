# frozen_string_literal: true

RSpec.describe ApplicationContract do
  it { expect(described_class).to be < Reform::Form }
  it { expect(described_class.ancestors).to include(Reform::Form::Dry) }
end
