# frozen_string_literal: true

module Macro
  def self.ModelRemove(path: [], type: :destroy)
    task = Trailblazer::Activity::TaskBuilder::Binary(
      ->(ctx, **) {
        model = ctx[path.shift]
        types = %i[destroy delete destroy! delete!]
        return unless types.include?(type)

        path.empty? ? model.public_send(type) : path.push(type).inject(model, :try)
      }
    )
    { task: task, id: "#{name}/#{__method__}_id_#{task.object_id}".underscore }
  end
end
