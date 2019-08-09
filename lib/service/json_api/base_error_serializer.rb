# frozen_string_literal: true

module Service
  module JsonApi
    class BaseErrorSerializer
      ERRORS_SOURCE = 'contract.default'

      private_class_method :new

      def self.call(result)
        new(result).jsonapi_errors_hash
      end

      def initialize(result, errors_source = ERRORS_SOURCE)
        @errors = result[errors_source].errors.messages
      end

      def jsonapi_errors_hash
        { errors: parse_errors }
      end

      private

      attr_reader :errors

      def parse_errors; end
    end
  end
end
