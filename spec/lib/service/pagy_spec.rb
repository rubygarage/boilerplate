# frozen_string_literal: true

RSpec.describe Service::Pagy do
  subject(:pagy_service) { described_class.call(collection, call_options) }

  let(:collection) { %w[1 2] }
  let(:call_options) { { **params, **options } }
  let(:params) { { page: 2, items: 1 } }

  context 'when active relation collection' do
    let(:options) { { elastic_collection: false } }
    let(:pagy_method) { :pagy }

    it 'prepares params class variable and calls pagy' do
      expect(described_class).to receive(pagy_method).with(collection, params)
      pagy_service
    end
  end
end
