# frozen_string_literal: true

module Macro
  def self.Model(entity:, connections: [], find_by_key: :id, params_key: :id, assign: false)
    task = ->((ctx, flow_options), **) {
      if assign
        Macro::Assign(to: :model, path: [*entity, *connections], try: true)[:task].call(ctx)
      else
        ctx[:model] = Model.find_relation(ctx[entity], connections, find_by_key, ctx[:params][params_key])
      end

      ctx['result.model'] = Model.result(ctx[:model])

      [Model.direction(ctx[:model].present?), [ctx, flow_options]]
    }

    { task: task, id: "#{entity}_model_id#{task.object_id}" }
  end

  module Model
    def self.direction(result)
      return Trailblazer::Activity::Right if result

      Trailblazer::Activity::Left
    end

    def self.result(model)
      Trailblazer::Operation::Result.new(model.present?, model)
    end

    def self.find_relation(entity, connections, find_by_key, params_key)
      connections.inject(entity, :public_send).find_by(find_by_key => params_key)
    end
  end
end
