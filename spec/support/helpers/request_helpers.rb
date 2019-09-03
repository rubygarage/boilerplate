# frozen_string_literal: true

module Helpers
  module RequestHelpers
    def auth_header(account)
      "Bearer #{create_token(:access, account: account)}"
    end

    def resource_type(response)
      body = JSON.parse(response.body)
      dig_params = body['data'].is_a?(Array) ? ['data', 0, 'type'] : %w[data type]
      body.dig(*dig_params)
    end
  end
end
