# frozen_string_literal: true

module Api::V1::Users::Lib::Service
  module TokenNamespace
    def self.call(namespace, entity_id)
      "#{namespace}-#{entity_id}"
    end
  end
end
