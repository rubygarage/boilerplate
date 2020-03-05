# frozen_string_literal: true

RSpec.describe Macro do
  describe '.LinksBuilder' do
    subject(:result) { operation.call({}) }

    context 'when required JsonapiPaginator args not exist' do
      let(:operation) do
        Class.new(Trailblazer::Operation) do
          step Macro::LinksBuilder()
        end
      end

      it 'not sets links into result' do
        expect(Service::JsonApi::Paginator).not_to receive(:call)
        expect(result[:links]).to be_nil
      end
    end

    context 'when required JsonapiPaginator args exist' do
      let(:operation) do
        Class.new(Trailblazer::Operation) do
          step ->(ctx, **) { ctx[:pagy] = :pagy }
          step Macro::LinksBuilder(resource_path: :some_path)
        end
      end

      it 'sets links into result' do
        expect(Service::JsonApi::Paginator).to receive(:call).and_return(true)
        expect(Rails).to receive_message_chain(:application, :routes, :url_helpers, :some_path).and_return(true)
        expect(result[:links]).to eq(true)
      end
    end

    context 'when ids is passed' do
      let(:resource_identifier) { rand(1..100) }
      let(:operation) do
        resource_id = resource_identifier
        Class.new(Trailblazer::Operation) do
          step ->(ctx, **) { ctx[:params] = { resource_id: resource_id } }
          step ->(ctx, **) { ctx[:pagy] = 'pagy' }
          step Macro::LinksBuilder(
            resource_path: :api_v1_resource_another_resources_path,
            ids: %i[resource_id]
          )
        end
      end

      it 'sets links into result' do
        expect(Service::JsonApi::Paginator).to receive(:call).and_return(true)
        expect(Rails).to(
          receive_message_chain(
            :application, :routes, :url_helpers, :api_v1_resource_another_resources_path
          ).with(resource_identifier).and_return(true)
        )
        expect(result[:links]).to eq(true)
      end
    end

    describe 'macro id' do
      it 'has formatted id' do
        expect(described_class::LinksBuilder({})[:id]).to macro_id_with('links_builder')
      end

      it 'has uniqueness id' do
        expect(described_class::LinksBuilder()[:id]).not_to eq(described_class::LinksBuilder()[:id])
      end
    end
  end
end
