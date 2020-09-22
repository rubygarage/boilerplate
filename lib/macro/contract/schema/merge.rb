# frozen_string_literal: true

module Macro
  module Contract
    module Schema
      module Merge
        def merge!(errors, prefix)
          errors.messages.each do |field, msgs|
            field = (prefix + [field]).join('.').to_sym unless field.to_sym == :base

            msgs.each do |msg|
              next if messages[field]&.include?(msg)

              add(field, msg)
            end
          end
        end
      end
    end
  end
end
