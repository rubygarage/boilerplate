# frozen_string_literal: true

RSpec.describe Macro do
  describe '.Assign' do
    subject(:result) { described_class::Assign(**params)[:task].call(ctx, flow_options) }

    let(:params) { {} }

    let(:object) { instance_double('SomeObject', some_method: 'method context') }
    let(:ctx) { { object: object } }
    let(:flow_options) { {} }

    context 'when path passed' do
      let(:to) { :model }
      let(:params) { { to: to, path: %i[object some_method] } }

      it 'assigns object.some_method context into specified ctx key' do
        result
        expect(ctx[to]).to eq(object.some_method)
      end
    end

    context 'when value passed' do
      let(:to) { :model }
      let(:value) { :value }
      let(:params) { { to: to, path: %i[object some_method], value: value } }

      it 'assigns specified value into specified ctx key' do
        result
        expect(ctx[to]).to eq(value)
      end
    end

    context 'when try is set up' do
      let(:to) { :model }
      let(:object) { nil }
      let(:params) { { to: to, path: %i[object not_existing_method], try: true } }

      it 'uses safe call' do
        expect(object).to receive(:try).with(:not_existing_method).and_call_original
        result
        expect(ctx[to]).to be_nil
      end
    end
  end
end
