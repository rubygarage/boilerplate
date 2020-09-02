# frozen_string_literal: true

module Macro
  class Semantic
    def call(success: nil, failure: nil, **)
      task = Trailblazer::Activity::TaskBuilder::Binary(
        ->(ctx, **) {
          ctx[:semantic_success], ctx[:semantic_failure] = success, failure
          true
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
