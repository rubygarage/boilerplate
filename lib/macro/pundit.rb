# frozen_string_literal: true

module Macro # :reek:MissingSafeMethod { exclude: [ result! ] }
  module Policy
    def self.Pundit(policy_class, action, user: nil, model: nil, name: :default)
      Trailblazer::Macro::Policy.step(Pundit.build(policy_class, action, user: user, model: model), name: name)
    end

    module Pundit
      def self.build(*args, &block)
        Condition.new(*args, &block)
      end

      class Condition
        def initialize(policy_class, action, user: nil, model: nil)
          @policy_class, @user, @model, @action = policy_class, user, model, action
        end

        def call((options), *)
          policy = build_policy(options)
          result!(policy.send(@action), policy)
        end

        private

        def build_policy(options)
          @policy_class.new(@user, @model) if @user && @model
          @policy_class.new(options[:current_user], options[:model]) unless @user && @model
        end

        def result!(success, policy)
          data = { policy: policy }
          data[:message] = 'Breach' unless success

          Trailblazer::Operation::Result.new(success, data)
        end
      end
    end
  end
end
