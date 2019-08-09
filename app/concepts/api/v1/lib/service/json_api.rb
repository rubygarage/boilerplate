# frozen_string_literal: true

module Api::V1::Lib::Service::JsonApi
  Column = Struct.new(:name, :type, :sortable, :filterable, keyword_init: true) do
    def initialize(name:, type: :string, **args)
      super
    end
  end

  module ColumnsBuilder
    def self.call(*columns)
      columns.map { |column| Api::V1::Lib::Service::JsonApi::Column.new(column) }
    end
  end
end
