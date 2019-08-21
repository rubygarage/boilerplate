# frozen_string_literal: true

module Api::V1::Lib::Serializer
  class Account < ApplicationSerializer
    set_type :account
    attributes :email, :created_at
  end
end
