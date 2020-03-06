# frozen_string_literal: true

module Macro
  def self.Assign(to:, path: [], value: nil, try: false)
    task = Trailblazer::Activity::TaskBuilder::Binary(
      ->(ctx, **) {
        method_name = try ? :try : :public_send
        ctx[to] = value || path.drop(1).inject(ctx[path.first], method_name)
      }
    )
    { task: task, id: "#{name}/#{__method__}_#{path.join('.')}_to_#{to}_id_#{task.object_id}".underscore }
  end
end
