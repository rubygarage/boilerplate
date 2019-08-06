# frozen_string_literal: true

module Macro
  def self.ModelDestroy(path: [])
    step = ->(ctx, **) {
      model = ctx[path.shift]
      path.empty? ? model.destroy : path.push(:destroy).inject(model, :try)
    }
    task = Trailblazer::Activity::TaskBuilder::Binary(step)
    { task: task, id: "#{name}/#{__method__}".underscore }
  end
end
