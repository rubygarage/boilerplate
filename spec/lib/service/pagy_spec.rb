# frozen_string_literal: true

RSpec.describe Service::Pagy do
  subject(:pagy_service) { described_class.call(collection, call_options) }

  let(:call_options) { { **params } }
  let(:params) { { page: 2, items: 1 } }

  context 'when active relation collection' do
    let(:collection) { Set.new(%w[1 2]) }
    let(:pagy_method) { :pagy }

    it 'prepares params class variable and calls pagy' do
      expect(described_class).to receive(pagy_method).with(collection, params)
      pagy_service
    end
  end

  context 'when array collection' do
    let(:collection) { %w[1 2] }
    let(:pagy_method) { :pagy_array }

    it 'prepares params class variable and calls pagy' do
      expect(described_class).to receive(pagy_method).with(collection, params)
      pagy_service
    end
  end
end
