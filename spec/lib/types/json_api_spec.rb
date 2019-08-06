# frozen_string_literal: true

module Types
  RSpec.describe JsonApi::Filter do
    subject(:result) { described_class.call(uri_filter_parameters) }

    let(:column) { 'column' }
    let(:predicate) { 'predicate' }
    let(:column_predicate) { "#{column}-#{predicate}" }
    let(:value) { 42 }
    let(:uri_filter_parameter) { [column_predicate, value] }
    let(:uri_filter_parameters) { [uri_filter_parameter] }

    it { expect(result).to eq([{ column: column, predicate: predicate, value: value }]) }
  end

  RSpec.describe JsonApi::Sort do
    subject(:result) { described_class.call(uri_sort_parameter) }

    %w[attr_1 attr_2 attr_3].each { |item| let(item) { item } }
    let(:uri_sort_parameter) { "#{attr_1},#{attr_2},#{attr_3}" }

    it { expect(result).to eq([attr_1, attr_2, attr_3]) }
  end

  RSpec.describe JsonApi::Include do
    it { expect(subject).to eq(JsonApi::Sort) } # rubocop:disable RSpec/NamedSubject
  end
end
