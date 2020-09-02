# frozen_string_literal: true

module Macro
  class Renderer
    def call(serializer: ApplicationSerializer, meta: nil, **)
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
      current_class = self.class
      {
        task: task,
        id: "#{current_class.module_parent_name}/#{current_class.name.split('::').last}_id_#{task.object_id}".underscore
      }
    end
  end
end
