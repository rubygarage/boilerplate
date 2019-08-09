# frozen_string_literal: true

RSpec.describe Service::JsonApi::ResourceSerializer do
  describe '.call' do
    class TestSerializer # rubocop:disable RSpec/LeakyConstantDeclaration
      include FastJsonapi::ObjectSerializer
      set_type :test_object
      attributes :test_attribute
    end

    subject(:jsonapi_serializer) { described_class.call(result_instance) }

    let(:test_object) { instance_double('TestObject', id: 1, test_attribute: 'test_attribute') }
    let(:result_instance) do
      {
        renderer:
          {
            serializer: TestSerializer,
            meta: 'meta'
          },
        model: test_object
      }
    end

    it 'return test serializer instance' do
      expect(jsonapi_serializer).to be_an_instance_of(TestSerializer)
      expect(jsonapi_serializer.to_hash).to include(
        data:
          {
            attributes: { test_attribute: 'test_attribute' },
            id: '1',
            type: :test_object
          },
        meta: 'meta'
      )
    end
  end
end
