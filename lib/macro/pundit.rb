# frozen_string_literal: true

module Policy
  def self.Pundit(policy_class, user: nil, model: nil, action, name: :default)
    Policy.step(Pundit.build(policy_class, user, model, action), name: name)
  end

  module Pundit
    def self.build(*args, &block)
      Condition.new(*args, &block)
    end

    class Condition
      def initialize(policy_class, user, model, action)
        @policy_class, @user, @model, @action = policy_class, user, model, action
      end

      def call((options), *)
        policy = build_policy
        result!(policy.send(@action), policy)
      end

    private
      def build_policy
        @policy_class.new(@user, @model) if @user && @model
        @policy_class.new(options[:current_user], options[:model]) unless @user && @model
      end

      def result!(success, policy)
        data = { policy: policy }
        data[:message] = "Breach" if !success

        Trailblazer::Operation::Result.new(success, data)
      end
    end
  end
end
