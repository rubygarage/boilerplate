# frozen_string_literal: true

RSpec.describe DefaultEndpoint do
  let(:test_class) do
    Class.new do
      include DefaultEndpoint
      attr_reader :params

      define_method(:initialize) { |params:| @params = params }
      %i[head render].each { |method| define_method(method) { |_| } }
    end
  end

  let(:test_class_instance) { test_class.new(params: instance_double('Params', to_unsafe_hash: {})) }
  let(:result) { {} }
  let(:http_status) { 'http_status' }

  describe '#default_handler' do
    def test_matcher(for_case = {})
      Dry::Matcher.new(
        %i[created destroyed unauthorized not_found forbidden gone accepted invalid bad_request success].map do |matcher| # rubocop:disable Metrics/LineLength
          [matcher, Dry::Matcher::Case.new(match: ->(_) { for_case[matcher] })]
        end.to_h
      )
    end

    shared_examples 'calls specific method' do
      it do
        expect(test_class_instance).to receive(expected_method).with(*args)
        test_matcher(matcher_case).call(result, &test_class_instance.default_handler)
      end
    end

    it { expect(test_class_instance.default_handler).to be_an_instance_of(Proc) }

    context 'when created matcher' do
      let(:matcher_case) { { created: true } }

      context 'when renderer options exists' do
        let(:result) { { renderer: {} } }
        let(:expected_method) { :render_response }
        let(:args) { [result, :created] }

        it_behaves_like('calls specific method')
      end

      context 'when renderer options not exists' do
        let(:expected_method) { :head }
        let(:args) { [:created] }

        it_behaves_like('calls specific method')
      end
    end

    context 'when destroyed matcher' do
      let(:matcher_case) { { destroyed: true } }
      let(:expected_method) { :head }
      let(:args) { [:no_content] }

      it_behaves_like('calls specific method')
    end

    context 'when unauthorized matcher' do
      let(:matcher_case) { { unauthorized: true } }

      context 'when contract default exists' do
        let(:result) { { 'contract.default' => {} } }
        let(:expected_method) { :render_head_or_errors }
        let(:args) { [result, :unauthorized] }

        it_behaves_like('calls specific method')
      end

      context 'when contract default not exists' do
        let(:expected_method) { :head }
        let(:args) { [:unauthorized] }

        it_behaves_like('calls specific method')
      end
    end

    context 'when not_found matcher' do
      let(:matcher_case) { { not_found: true } }
      let(:expected_method) { :head }
      let(:args) { [:not_found] }

      it_behaves_like('calls specific method')
    end

    context 'when forbidden matcher' do
      let(:matcher_case) { { forbidden: true } }
      let(:expected_method) { :head }
      let(:args) { [:forbidden] }

      it_behaves_like('calls specific method')
    end

    context 'when gone matcher' do
      let(:matcher_case) { { gone: true } }
      let(:expected_method) { :head }
      let(:args) { [:gone] }

      it_behaves_like('calls specific method')
    end

    context 'when gone matcher' do
      let(:matcher_case) { { accepted: true } }
      let(:expected_method) { :head }
      let(:args) { [:accepted] }

      it_behaves_like('calls specific method')
    end

    context 'when invalid matcher' do
      let(:matcher_case) { { invalid: true } }
      let(:expected_method) { :render }
      let(:args) { [{ jsonapi: true, status: :unprocessable_entity }] }

      it do
        expect(Service::JsonApi::ResourceErrorSerializer).to receive(:call).and_return(true)
        expect(test_class_instance).to receive(expected_method).with(*args)
        test_matcher(matcher_case).call(result, &test_class_instance.default_handler)
      end
    end

    context 'when bad_request matcher' do
      let(:matcher_case) { { bad_request: true } }
      let(:expected_method) { :render }
      let(:args) { [{ jsonapi: true, status: :bad_request }] }

      it do
        expect(Service::JsonApi::UriQueryErrorSerializer).to receive(:call).and_return(true)
        expect(test_class_instance).to receive(expected_method).with(*args)
        test_matcher(matcher_case).call(result, &test_class_instance.default_handler)
      end
    end

    context 'when success matcher' do
      let(:matcher_case) { { success: true } }

      context 'when renderer options exists' do
        let(:result) { { renderer: {} } }
        let(:expected_method) { :render }
        let(:args) { [{ jsonapi: true, status: :ok }] }

        it do
          expect(Service::JsonApi::ResourceSerializer).to receive(:call).and_return(true)
          expect(test_class_instance).to receive(expected_method).with(*args)
          test_matcher(matcher_case).call(result, &test_class_instance.default_handler)
        end
      end

      context 'when renderer options not exists' do
        let(:expected_method) { :head }
        let(:args) { [:no_content] }

        it_behaves_like('calls specific method')
      end
    end
  end

  describe '#endpoint' do
    let(:options) { { params: {} } }
    let(:operation_class) { :operation_class }

    it do
      expect(test_class_instance).to receive(:default_handler).and_return(:default_handler)
      expect(ApplicationEndpoint).to receive(:call).with(operation_class, :default_handler, options)
      test_class_instance.endpoint(operation_class)
    end
  end
end
