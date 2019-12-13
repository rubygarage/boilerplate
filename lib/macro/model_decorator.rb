# frozen_string_literal: true

module Macro
  def self.ModelDecorator(decorator:, **)
    step = ->(ctx, **) {
      model = ctx[:model]
      ctx[:model] = decorator.public_send(
        (model.is_a?(Enumerable) ? :decorate_collection : :decorate), model
      )
    }
    task = Trailblazer::Activity::TaskBuilder::Binary(step)
    { task: task, id: "model_decorator_id#{task.object_id}" }
  end
end
