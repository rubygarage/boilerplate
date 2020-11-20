# frozen_string_literal: true

RSpec.describe Macro do
  describe '.Pundit' do
    class Auth
      def only_user?
        @user == Module && @model.nil?
      end
    end

    # rubocop:disable RSpec/LeakyConstantDeclaration
    OperationPolicyPundit = Class.new(Trailblazer::Operation) do
      step Macro::Policy::Pundit(Auth, :only_user?)
      step :process

      def process(options, **)
        options[:process] = true
      end
    end
    # rubocop:enable RSpec/LeakyConstantDeclaration

    context 'when successful' do
      let(:result) { OperationPolicyPundit.call(params: {}, current_user: Module) }

      it 'process to be truthy' do
        expect(result[:process]).to be true
      end
    end

    context 'when breach' do
      let(:result) { OperationPolicyPundit.call(params: {}, current_user: nil) }

      it 'process to be falsey' do
        expect(result[:process]).to be nil
      end
    end
  end
end
