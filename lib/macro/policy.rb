# frozen_string_literal: true

module Macro
  def self.Policy(policy_class, rule, policy_params: nil, name: :default, model: :model, **)
    task = ->((ctx, flow_options), **) {
      policy_namespace = :"macro.policy.#{name}"
      ctx[policy_namespace] = policy_class.new(ctx[:current_user], ctx[model])
      result = if policy_params
                 ctx[policy_namespace].public_send(rule, ctx[:policy_params])
               else
                 ctx[policy_namespace].public_send(rule)
               end
      unless result
        message = "#{policy_class.name.demodulize.underscore}.#{rule}" || 'default'
        current_errors = ctx[:errors] || {}
        ctx[:errors] = current_errors.deep_merge(
          {
            policy: [I18n.t("policy.errors.#{message}")]
          }
        )

        ctx[:semantic_failure] = :forbidden
      end

      signal = result ? Trailblazer::Activity::Right : Trailblazer::Activity::Left
      [signal, [ctx, flow_options]]
    }

    { task: task, id: "#{name}/#{__method__}_id_#{task.object_id}".underscore }
  end
end
