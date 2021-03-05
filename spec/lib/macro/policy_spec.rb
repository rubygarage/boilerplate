# frozen_string_literal: true

RSpec.describe Macro do
  describe '.Policy' do
    subject(:result) { described_class::Policy(policy_class, rule)[:task].call(ctx, **flow_options) }

    let(:flow_options) { {} }
    let(:rule) { :update_role? }
    let(:ctx) { {} }
    let(:policy_class) { TestPolicy }

    before { stub_const('TestPolicy', Struct.new(:TestPolicy)) }

    context 'when set policy_params to true' do
      subject(:result) do
        described_class::Policy(policy_class,
                                rule,
                                policy_params: true)[:task].call(ctx, **flow_options)
      end

      let(:ctx) { { policy_params: true } }

      it 'is allowed' do
        expect(policy_class).to receive_message_chain(:new, rule).with(ctx[:policy_params]).and_return(true)
        expect(result[0]).to eq(Trailblazer::Activity::Right)
      end
    end

    context 'when current_user in have access to model' do
      before do
        allow(policy_class).to receive_message_chain(:new, rule).and_return(true)
      end

      it 'is allowed' do
        expect(result[0]).to eq(Trailblazer::Activity::Right)
        expect(ctx[:semantic_failure]).to be_nil
      end

      it 'is put policy in right namespace' do
        expect(result.second.first[:'macro.policy.default']).to be_instance_of(RSpec::Mocks::Double)
        expect(result[1][0][:'macro.policy.default']).to be_respond_to(rule)
      end
    end

    context 'when current_user in have not access to model' do
      before do
        allow(policy_class).to receive_message_chain(:new, rule).and_return(false)
      end

      it 'is not allowed' do
        expect(result[0]).to eq(Trailblazer::Activity::Left)
        expect(ctx[:semantic_failure]).to eq(:forbidden)
      end
    end

    context 'when other than default namespace' do
      subject(:result) { described_class::Policy(policy_class, rule, name: 'custom')[:task].call(ctx, **flow_options) }

      before do
        allow(policy_class).to receive_message_chain(:new, rule).and_return(true)
      end

      it 'is put policy in right namespace' do
        expect(result[0]).to eq(Trailblazer::Activity::Right)
        expect(result[1][0][:'macro.policy.custom']).to be_instance_of(RSpec::Mocks::Double)
        expect(result[1][0][:'macro.policy.custom']).to be_respond_to(rule)
        expect(result[1][0][:'macro.policy.default']).not_to be_present
      end
    end
  end
end
