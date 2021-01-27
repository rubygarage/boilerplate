# frozen_string_literal: true

module Macro
  def self.ModelRemove(path: [], type: :destroy)
    task = Trailblazer::Activity::TaskBuilder::Binary(
      ->(ctx, **) {
        model = ctx[path.first]
        types = %i[destroy delete destroy! delete!]
        call_chain = path[1..]
        return unless types.include?(type)

        call_chain.empty? ? model.public_send(type) : call_chain.push(type).inject(model, :try)
      }
    )
    { task: task, id: "#{name}/#{__method__}_id_#{task.object_id}".underscore }
  end
end
