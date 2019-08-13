# frozen_string_literal: true

module Api::V1::Users::Sessions::Serializer
  class Create < ApplicationSerializer
    set_type :account
    attributes :email, :created_at
  end
end
