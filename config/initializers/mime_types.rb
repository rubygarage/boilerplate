# frozen_string_literal: true

JSONAPI_MEDIA_TYPE = 'application/vnd.api+json'

Mime::Type.register(JSONAPI_MEDIA_TYPE, :jsonapi)

ActionController::Renderers.add(:jsonapi) do |json, options|
  json = json.to_json(options) unless json.is_a?(String)
  self.content_type ||= Mime[:jsonapi]
  self.response_body = json
end
