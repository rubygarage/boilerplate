# frozen_string_literal: true

module Macro
  class Decorate
    def call(decorator: nil, from: :model, to: :model, **)
      task = Trailblazer::Activity::TaskBuilder::Binary(
        ->(ctx, **) {
          model = ctx[from]
          ctx[to] = (decorator || ctx[:decorator]).public_send(
            (model.is_a?(Enumerable) ? :decorate_collection : :decorate), model
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
