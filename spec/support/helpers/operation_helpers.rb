# frozen_string_literal: true

module Helpers
  module OperationHelpers
    def create_available_columns(*columns)
      Api::V1::Lib::Service::JsonApi::ColumnsBuilder.call(*columns)
    end
  end
end
