# frozen_string_literal: true

module Macro
  def self.Renderer(serializer: ApplicationSerializer, meta: nil, **)
    step = ->(ctx, **) {
      ctx[:renderer] =
        {
          serializer: serializer,
          include: ctx[:inclusion_options],
          links: ctx[:links],
          meta: meta ? ctx[meta] : nil
        }.compact
    }
    task = Trailblazer::Activity::TaskBuilder::Binary(step)
    { task: task, id: 'renderer' }
  end
end
