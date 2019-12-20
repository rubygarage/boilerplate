# frozen_string_literal: true

module Macro
  def self.ModelDestroy(path: [])
    task = Trailblazer::Activity::TaskBuilder::Binary(
      ->(ctx, **) {
        model = ctx[path.shift]
        path.empty? ? model.destroy : path.push(:destroy).inject(model, :try)
      }
    )
    { task: task, id: "#{name}/#{__method__}_id_#{task.object_id}".underscore }
  end
end
