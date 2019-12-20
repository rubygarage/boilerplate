# frozen_string_literal: true

module Macro
  def self.ModelDecorator(decorator: nil, to: :model, **)
    task = Trailblazer::Activity::TaskBuilder::Binary(
      ->(ctx, **) {
        model = ctx[:model]
        ctx[to] = (decorator || ctx[:decorator]).public_send(
          (model.is_a?(Enumerable) ? :decorate_collection : :decorate), model
        )
      }
    )
    { task: task, id: "#{name}/#{__method__}_id_#{task.object_id}".underscore }
  end
end
