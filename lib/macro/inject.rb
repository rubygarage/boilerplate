# frozen_string_literal: true

module Macro
  class Inject
    def call(**deps)
      task = Trailblazer::Activity::TaskBuilder::Binary(
        ->(ctx, **) {
          deps.each { |key, value| ctx[key] = value.is_a?(String) ? Container[value] : value }
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
