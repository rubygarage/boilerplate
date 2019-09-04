# frozen_string_literal: true

module DefaultEndpoint
  def default_handler
    lambda do |match|
      match.created      { |result| render_head_or_response(result, :created) }
      match.destroyed    { head(:no_content) }
      match.unauthorized { |result| render_head_or_errors(result, :unauthorized) }
      match.not_found    { head(:not_found) }
      match.forbidden    { head(:forbidden) }
      match.gone         { head(:gone) }
      match.accepted     { head(:accepted) }
      match.invalid      { |result| render_errors(result, :unprocessable_entity) }
      match.success      { |result| success_response(result) }
      match.bad_request  { |result| render_errors(result, :bad_request) }
    end
  end

  def endpoint(operation, options: {}, &block)
    ApplicationEndpoint.call(
      operation,
      default_handler,
      { params: params.to_unsafe_hash, **operation_options(options) },
      &block
    )
  end

  private

  def operation_options(options)
    options
  end

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
