# frozen_string_literal: true

module Macro
  module Contract
    module Schema
      # :reek:DuplicateMethodCall
      class Errors
        def initialize(*)
          @errors = {}
        end

        def add(field, message)
          @errors[field] ||= []
          @errors[field] << message
        end

        def messages
          @errors
        end
      end
    end
  end
end
