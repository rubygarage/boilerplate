# frozen_string_literal: true

module Macro
  module Contract
    module Schema
      # :reek:DuplicateMethodCall
      class Errors
        include Macro::Contract::Schema::Merge

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
