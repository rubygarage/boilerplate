# frozen_string_literal: true

module Macro
  class Assign
    def call(to:, path: [], value: nil, try: false)
      task = Trailblazer::Activity::TaskBuilder::Binary(
        ->(ctx, **) {
          method_name = try ? :try : :public_send
          ctx[to] = value || path.drop(1).inject(ctx[path.first], method_name)
        }
      )
      current_class = self.class
      class_name = current_class.name.split('::').last
      module_name = current_class.module_parent_name
      {
        task: task,
        id: "#{module_name}/#{class_name}_#{path.join('.')}_to_#{to}_id_#{task.object_id}".underscore
      }
    end
  end
end
