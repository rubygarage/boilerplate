# frozen_string_literal: true

module Macro
  def self.ModelDecorator(decorator:, **)
    task = ->((ctx, flow_options), **) {
      model = ctx[:model]
      ctx[:model] = decorator.public_send(
        (model.is_a?(Enumerable) ? :decorate_collection : :decorate), model
      )

      [Trailblazer::Activity::Right, [ctx, flow_options]]
    }

    { task: task, id: "model_decorator_id#{task.object_id}" }
  end
end
