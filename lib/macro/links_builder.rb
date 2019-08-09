# frozen_string_literal: true

module Macro
  def self.LinksBuilder(resource_path: nil, ids: [], **)
    task = ->((ctx, flow_options), **) {
      pagy = ctx[:pagy]
      resource_ids = ids.map { |id| ctx[:params][id] }
      ctx[:links] =
        if resource_path && pagy
          Service::JsonApi::Paginator.call(
            resource_path: Rails.application.routes.url_helpers.public_send(*[resource_path, *resource_ids].compact),
            pagy: pagy
          )
        end

      [Trailblazer::Activity::Right, [ctx, flow_options]]
    }

    { task: task, id: 'links_builder' }
  end
end
