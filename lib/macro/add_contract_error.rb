# frozen_string_literal: true

module Macro
  def self.AddContractError(name: :default, **args)
    step = ->(ctx, **) {
      error, message = args.first
      ctx["contract.#{name}"].errors.add(
        error, message.is_a?(Array) ? message : I18n.t(message)
      )
    }
    task = Trailblazer::Activity::TaskBuilder::Binary(step)
    { task: task, id: "add_contract_error_id#{task.object_id}" }
  end
end
