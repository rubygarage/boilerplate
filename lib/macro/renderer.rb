# frozen_string_literal: true

module Macro
  def self.Renderer(serializer: ApplicationSerializer, meta: nil, **)
    task = Trailblazer::Activity::TaskBuilder::Binary(
      ->(ctx, **) {
        ctx[:renderer] =
          {
            serializer: serializer,
            include: ctx[:inclusion_options],
            links: ctx[:links],
            meta: meta ? ctx[meta] : nil
          }.compact
      }
    )
    { task: task, id: "#{name}/#{__method__}_id_#{task.object_id}".underscore }
  end
end
