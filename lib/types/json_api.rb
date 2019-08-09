# frozen_string_literal: true

module Types
  include Dry::Types.module

  FilterObject = Struct.new(:column, :predicate, :value)
  SortObject = Struct.new(:column, :order)

  module JsonApi
    module TypeByColumn
      def self.call(column)
        {
          string: ::Types::String,
          number: ::Types::Form::Int | ::Types::Form::Decimal,
          boolean: ::Types::Form::Nil,
          date: ::Types::Form::Date | ::Types::Form::Int
        }[column]
      end
    end

    Filter = Types::Array.constructor do |parameter|
      parameter.map do |key, value|
        column, predicate = key.split('-')
        Types::FilterObject.new(column, predicate, value)
      end
    end

    Sort = Types::Array.constructor do |parameter|
      parameter.split(',').map do |sort_object|
        order, column = sort_object.scan(::JsonApi::Sorting::JSONAPI_SORT_PATTERN).flatten
        Types::SortObject.new(column, order ? :desc : :asc)
      end
    end

    Include = Types::Array.constructor { |parameter| parameter.split(',') }
  end
end
