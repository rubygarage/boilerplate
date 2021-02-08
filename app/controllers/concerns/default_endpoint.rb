# frozen_string_literal: true

module DefaultEndpoint
  def default_cases
    {
      created:      -> (result) { render_head_or_response(result, :created) },
      destroyed:    -> (result) { head(:no_content) },
      unauthorized: -> (result) { render_head_or_errors(result, :unauthorized) },
      not_found:    -> (result) { render_head_or_errors(result, :not_found) },
      forbidden:    -> (result) { render_head_or_errors(result, :forbidden) },
      gone:         -> (result) { render_head_or_errors(result, :gone) },
      accepted:     -> (result) { head(:accepted) },
      invalid:      -> (result) { render_errors(result, :unprocessable_entity) },
      success:      -> (result) { success_response(result) },
      bad_request:  -> (result) { render_errors(result, :bad_request) }
    }
  end

  private

  def render_response(result, status)
    render(jsonapi: Service::JsonApi::ResourceSerializer.call(result), status: status)
  end

  def render_head_or_response(result, status)
    renderer = result[:renderer]
    renderer ? render_response(result, status) : head(status)
  end

  def success_response(result)
    status = result[:renderer] ? :ok : :no_content
    render_head_or_response(result, status)
  end

  def render_errors(result, status)
    render(jsonapi: error_serializer_by_status(status).call(result), status: status)
  end

  def render_head_or_errors(result, status)
    errors = result['contract.default']
    errors ? render_errors(result, status) : head(status)
  end

  def error_serializer_by_status(status)
    return Service::JsonApi::UriQueryErrorSerializer if status.eql?(:bad_request)

    Service::JsonApi::ResourceErrorSerializer
  end
end
