# frozen_string_literal: true

class ApplicationEndpoint < Trailblazer::Endpoint
  MATCHER = Dry::Matcher.new(
    created: Dry::Matcher::Case.new(
      match: ->(result) {
        result.success? && result[:semantic_success] == :created
      }
    ),
    destroyed: Dry::Matcher::Case.new(
      match: ->(result) {
        result.success? && (result[:model].try(:destroyed?) || result[:semantic_success] == :destroyed)
      }
    ),
    unauthorized: Dry::Matcher::Case.new(
      match: ->(result) {
        result.failure? && result[:semantic_failure] == :unauthorized
      }
    ),
    not_found: Dry::Matcher::Case.new(
      match: ->(result) {
        result.failure? && (result['result.model']&.failure? || result[:semantic_failure] == :not_found)
      }
    ),
    forbidden: Dry::Matcher::Case.new(
      match: ->(result) {
        result.failure? && (result['result.policy.default']&.failure? || result[:semantic_failure] == :forbidden)
      }
    ),
    gone: Dry::Matcher::Case.new(
      match: ->(result) {
        result.failure? && result[:semantic_failure] == :gone
      }
    ),
    accepted: Dry::Matcher::Case.new(
      match: ->(result) {
        result.success? && result[:semantic_success] == :accepted
      }
    ),
    invalid: Dry::Matcher::Case.new(
      match: ->(result) {
        result.failure? && result['contract.default']&.errors.present?
      }
    ),
    success: Dry::Matcher::Case.new(
      match: ->(result) {
        result.success?
      }
    ),
    bad_request: Dry::Matcher::Case.new(
      match: ->(result) {
        result.failure? &&
          (result[:semantic_failure] == :bad_request || result['contract.uri_query']&.errors.present?)
      }
    )
  )

  def matcher
    ApplicationEndpoint::MATCHER
  end
end
