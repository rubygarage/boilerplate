# frozen_string_literal: true

class Account < ApplicationRecord
  has_secure_password
  has_one :user, dependent: :destroy
end
