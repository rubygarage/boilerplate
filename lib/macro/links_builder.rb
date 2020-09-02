# frozen_string_literal: true

module Macro
  class LinksBuilder
    def call(resource_path: nil, ids: [], **)
      task = Trailblazer::Activity::TaskBuilder::Binary(
        ->(ctx, **) {
          pagy = ctx[:pagy]
          resource_ids = ids.map { |id| ctx[:params][id] }
          ctx[:links] =
            if resource_path && pagy
              Service::JsonApi::Paginator.call(
                resource_path: Rails.application.routes.url_helpers.public_send(*[resource_path,
                                                                                  *resource_ids].compact),
                pagy: pagy
              )
            end
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
