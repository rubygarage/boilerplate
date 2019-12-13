# frozen_string_literal: true

module Macro
  def self.Semantic(success: nil, failure: nil, **)
    step = ->(ctx, **) {
      ctx[:semantic_success], ctx[:semantic_failure] = success, failure
      true
    }
    task = Trailblazer::Activity::TaskBuilder::Binary(step)
    { task: task, id: "semantic_id#{task.object_id}" }
  end
end
