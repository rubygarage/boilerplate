# frozen_string_literal: true

module Service
  module JsonApi
    class UriQueryErrorSerializer < Service::JsonApi::BaseErrorSerializer
      ERRORS_SOURCE = 'contract.uri_query'

      def initialize(result)
        super(result, Service::JsonApi::UriQueryErrorSerializer::ERRORS_SOURCE)
      end

      private

      def compose_nested_errors(field, attribute_errors)
        attribute_errors.map do |nested_field, errors|
          {
            source: { pointer: "#{field}[#{nested_field}]" },
            detail: errors.join(', ')
          }
        end
      end

      def parse_errors
        errors.flat_map do |field, attribute_errors|
          if attribute_errors.flatten.any? { |item| !item.is_a?(String) }
            compose_nested_errors(field, attribute_errors)
          else
            { source: { pointer: field.to_s }, detail: attribute_errors.join }
          end
        end
      end
    end
  end
end
