# frozen_string_literal: true

module Types
  include Dry::Types.module
  module JsonApi
    Filter = Types::Array.constructor do |parameter|
      parameter.map do |key, value|
        column, predicate = key.split('-')
        { column: column, predicate: predicate, value: value }
      end
    end

    Sort = Types::Array.constructor { |parameter| parameter.split(',') }
    Include = Sort
  end
end
