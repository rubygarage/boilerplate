# frozen_string_literal: true

RSpec.describe Macro do
  describe '.Semantic' do
    subject(:result) { operation.call({}) }

    shared_examples 'sets semantic into context' do
      it { expect(result[semantic_marker]).to eq(:semantic_context) }
    end

    context 'when success value passed' do
      let(:semantic_marker) { :semantic_success }
      let(:operation) do
        Class.new(Trailblazer::Operation) do
          step Macro::Semantic(success: :semantic_context)
        end
      end

      include_examples 'sets semantic into context'
    end

    context 'when failure value passed' do
      let(:semantic_marker) { :semantic_failure }
      let(:operation) do
        Class.new(Trailblazer::Operation) do
          step Macro::Semantic(failure: :semantic_context)
        end
      end

      include_examples 'sets semantic into context'
    end
  end
end
