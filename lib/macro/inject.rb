# frozen_string_literal: true

module Macro
  def self.Inject(**deps)
    task = Trailblazer::Activity::TaskBuilder::Binary(
      ->(ctx, **) {
        deps.each { |key, value| ctx[key] = value.is_a?(String) ? Container[value] : value }
      }
    )
    { task: task, id: "#{name}/#{__method__}_id_#{task.object_id}".underscore }
  end
end
