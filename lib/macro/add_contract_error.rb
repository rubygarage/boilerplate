# frozen_string_literal: true

module Macro
  class AddContractError
    def call(name: :default, **args)
      task = Trailblazer::Activity::TaskBuilder::Binary(
        ->(ctx, **) {
          error, message = args.first
          ctx["contract.#{name}"].errors.add(
            error, message.is_a?(Array) ? message : I18n.t(message)
          )
        }
      )
      current_class = self.class
      {
        task: task,
        id: "#{current_class.module_parent_name}/#{current_class.name.split('::').last}_id_#{task.object_id}".underscore
      }
    end
  end
end
