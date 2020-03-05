# frozen_string_literal: true

module Macro
  def self.AddContractError(name: :default, **args)
    task = Trailblazer::Activity::TaskBuilder::Binary(
      ->(ctx, **) {
        error, message = args.first
        ctx["contract.#{name}"].errors.add(
          error, message.is_a?(Array) ? message : I18n.t(message)
        )
      }
    )
    { task: task, id: "#{self.name}/#{__method__}_id_#{task.object_id}".underscore }
  end
end
