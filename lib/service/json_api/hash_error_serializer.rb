# frozen_string_literal: true

module Service
  module JsonApi
    class HashErrorSerializer < Service::JsonApi::BaseErrorSerializer
      include Service::JsonApi::ErrorDataStructureParser

      def initialize(**result)
        @errors = result
      end
    end
  end
end
