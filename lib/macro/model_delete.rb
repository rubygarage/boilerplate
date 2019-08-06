# frozen_string_literal: true

module Macro
  def self.ModelDelete(path: [])
    step = ->(ctx, **) {
      model = ctx[path.shift]
      path.empty? ? model.delete : path.push(:delete).inject(model, :try)
    }
    task = Trailblazer::Activity::TaskBuilder::Binary(step)
    { task: task, id: "#{name}/#{__method__}".underscore }
  end
end
