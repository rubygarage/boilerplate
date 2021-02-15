# frozen_string_literal: true

module Api::V1::Users::Account
  class ProfilesController < AuthorizedApiController
    def show
      endpoint operation: Api::V1::Users::Account::Profiles::Operation::Show
    end
  end
end
