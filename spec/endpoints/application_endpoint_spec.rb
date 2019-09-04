# frozen_string_literal: true

RSpec.describe ApplicationEndpoint do
  describe '.call' do
    subject(:application_endpoint) do
      described_class.call(
        operation,
        handler,
        result_options.merge(
          semantic_name => semantic_context,
          result_condition: result_condition
        )
      )
    end

    let(:semantic_name) { :empty_semantic_name }
    let(:semantic_context) {}
    let(:result_options) { {} }

    let(:operation) do
      Class.new(Trailblazer::Operation) do
        step ->(ctx, **) { ctx[:result_condition] }
      end
    end

    let(:handler) do
      lambda do |match|
        match.created { handler_context }
        match.destroyed { handler_context }
        match.unauthorized { handler_context }
        match.not_found { handler_context }
        match.forbidden { handler_context }
        match.gone { handler_context }
        match.accepted { handler_context }
        match.invalid { handler_context }
        match.bad_request { handler_context }
        match.success { handler_context }
      end
    end

    shared_examples 'matched endpoint' do
      it { expect(application_endpoint).to eq(handler_context) }
    end

    describe ':create case matcher' do
      let(:handler_context) { 'create handler context' }
      let(:result_condition) { true }
      let(:semantic_name) { :semantic_success }
      let(:semantic_context) { :created }

      include_examples 'matched endpoint'
    end

    describe ':destroyed case matcher' do
      let(:handler_context) { 'destroyed handler context' }
      let(:result_condition) { true }

      context 'when result model destroyed' do
        let(:result_options) { { model: instance_double('Model', destroyed?: true) } }

        include_examples 'matched endpoint'
      end

      context 'when semantic' do
        let(:semantic_name) { :semantic_success }
        let(:semantic_context) { :destroyed }

        include_examples 'matched endpoint'
      end
    end

    describe ':unauthorized case matcher' do
      let(:handler_context) { 'unauthorized handler context' }
      let(:result_condition) { false }
      let(:semantic_name) { :semantic_failure }
      let(:semantic_context) { :unauthorized }

      include_examples 'matched endpoint'
    end

    describe ':not_found case matcher' do
      let(:handler_context) { 'not_found handler context' }
      let(:result_condition) { false }

      context 'when result model failure' do
        let(:result_options) { { 'result.model' => instance_double('Result', failure?: true) } }

        include_examples 'matched endpoint'
      end

      context 'when semantic' do
        let(:semantic_name) { :semantic_failure }
        let(:semantic_context) { :not_found }

        include_examples 'matched endpoint'
      end
    end

    describe ':forbidden case matcher' do
      let(:handler_context) { 'forbidden handler context' }
      let(:result_condition) { false }

      context 'when result policy failure' do
        let(:result_options) { { 'result.policy.default' => instance_double('Policy', failure?: true) } }

        include_examples 'matched endpoint'
      end

      context 'when semantic' do
        let(:semantic_name) { :semantic_failure }
        let(:semantic_context) { :forbidden }

        include_examples 'matched endpoint'
      end
    end

    describe ':gone case matcher' do
      let(:handler_context) { 'gone handler context' }
      let(:result_condition) { false }

      context 'when semantic is set to :bad_request' do
        let(:semantic_name) { :semantic_failure }
        let(:semantic_context) { :bad_request }

        include_examples 'matched endpoint'
      end

      context 'when contract.uri_query has errors' do
        let(:result_options) { { 'contract.uri_query' => instance_double('Contract', errors: { error: :error }) } }

        include_examples 'matched endpoint'
      end
    end

    describe ':accepted case matcher' do
      let(:handler_context) { 'accepted handler context' }
      let(:result_condition) { true }
      let(:semantic_name) { :semantic_success }
      let(:semantic_context) { :accepted }

      include_examples 'matched endpoint'
    end

    describe ':bad_request case matcher' do
      let(:handler_context) { 'bad_request handler context' }
      let(:result_condition) { false }

      context 'when semantic is set to :bad_request' do
        let(:semantic_name) { :semantic_failure }
        let(:semantic_context) { :bad_request }

        include_examples 'matched endpoint'
      end

      context 'when contract.uri_query has errors' do
        let(:result_options) { { 'contract.uri_query' => instance_double('Contract', errors: { error: :error }) } }

        include_examples 'matched endpoint'
      end
    end

    describe ':invalid case matcher' do
      let(:handler_context) { 'invalid handler context' }
      let(:result_condition) { false }
      let(:result_options) { { 'contract.default' => instance_double('Contract', errors: { error: :error }) } }

      include_examples 'matched endpoint'
    end

    describe ':success case matcher' do
      let(:handler_context) { 'success handler context' }
      let(:result_condition) { true }

      include_examples 'matched endpoint'
    end
  end
end
