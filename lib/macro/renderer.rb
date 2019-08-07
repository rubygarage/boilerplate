# frozen_string_literal: true

module Macro
  def self.Renderer(serializer: ApplicationSerializer, meta: nil, **)
    task = ->((ctx, flow_options), **) {
      ctx[:renderer] =
        {
          serializer: serializer,
          include: ctx[:inclusion_options],
          links: ctx[:links],
          meta: meta ? ctx[meta] : nil
        }.compact

      [Trailblazer::Activity::Right, [ctx, flow_options]]
    }

    { task: task, id: 'renderer' }
  end
end
