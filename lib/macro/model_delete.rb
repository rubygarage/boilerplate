# frozen_string_literal: true

module Macro
  class ModelDelete
    def call(path: [])
      task = Trailblazer::Activity::TaskBuilder::Binary(
        ->(ctx, **) {
          model = ctx[path.shift]
          path.empty? ? model.delete : path.push(:delete).inject(model, :try)
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
