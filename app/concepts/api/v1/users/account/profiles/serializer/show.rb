# frozen_string_literal: true

module Api::V1::Users::Account::Profiles::Serializer
  class Show < ApplicationSerializer
    set_type 'user-profile'
    attributes :name
    belongs_to :account, serializer: Api::V1::Lib::Serializer::Account
  end
end
