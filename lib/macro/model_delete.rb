# frozen_string_literal: true

module Macro
  def self.ModelDelete(path: [])
    task = Trailblazer::Activity::TaskBuilder::Binary(
      ->(ctx, **) {
        model = ctx[path.shift]
        path.empty? ? model.delete : path.push(:delete).inject(model, :try)
      }
    )
    { task: task, id: "#{name}/#{__method__}_id_#{task.object_id}".underscore }
  end
end
