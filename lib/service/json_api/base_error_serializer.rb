# frozen_string_literal: true

module Service
  module JsonApi
    class BaseErrorSerializer
      ERRORS_SOURCES = { contract_errors_matcher: 'contract.' }.freeze

      private_class_method :new

      def self.call(result)
        new(result).jsonapi_errors_hash
      end

      def initialize(result, errors_source = nil)
        @errors = custom_errors(result, errors_source) || contract_errors(result)
      end

      def jsonapi_errors_hash
        { errors: parse_errors }
      end

      private

      attr_reader :errors

      # :reek:UtilityFunction
      def custom_errors(result, errors_source)
        result[errors_source]&.errors&.messages
      end

      # :reek:UtilityFunction
      def contract_errors(result)
        contracts = result.keys.select do |result_key|
          result_key.start_with?(ERRORS_SOURCES[:contract_errors_matcher]) &&
            result[result_key].try(:errors)
        end.compact

        contracts.map { |contract| result[contract].errors.messages }.reduce(:merge)
      end

      def parse_errors; end
    end
  end
end
