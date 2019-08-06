# frozen_string_literal: true

module Macro
  def self.Assign(to:, path: [], value: nil, try: false)
    step = ->(ctx, **) {
      method_name = try ? :try : :public_send
      ctx[to] = value || path.drop(1).inject(ctx[path.first], method_name)
    }
    task = Trailblazer::Activity::TaskBuilder::Binary(step)
    { task: task, id: "assign_#{path.join('.')}_to_#{to}" }
  end
end
