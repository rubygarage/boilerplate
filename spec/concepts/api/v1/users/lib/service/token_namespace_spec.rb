# frozen_string_literal: true

RSpec.describe Api::V1::Users::Lib::Service::TokenNamespace do
  describe '.call' do
    subject(:service) { described_class.call(namespace, entity_id) }

    let(:namespace) { :namespace }
    let(:entity_id) { rand(1..42) }

    it 'returns interpolated token namespace' do
      expect(service).to eq("#{namespace}-#{entity_id}")
    end
  end
end
