# frozen_string_literal: true

module Macro
  def self.LinksBuilder(resource_path: nil, ids: [], **)
    step = ->(ctx, **) {
      pagy = ctx[:pagy]
      resource_ids = ids.map { |id| ctx[:params][id] }
      ctx[:links] =
        if resource_path && pagy
          Service::JsonApi::Paginator.call(
            resource_path: Rails.application.routes.url_helpers.public_send(*[resource_path, *resource_ids].compact),
            pagy: pagy
          )
        end
    }
    task = Trailblazer::Activity::TaskBuilder::Binary(step)
    { task: task, id: 'links_builder' }
  end
end
