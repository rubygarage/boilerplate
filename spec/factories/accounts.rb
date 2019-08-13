# frozen_string_literal: true

FactoryBot.define do
  factory :account do
    email { FFaker::Internet.unique.email }
    password { FFaker::Internet.password }
    password_confirmation { password }
    user { nil }

    trait :with_user do
      user
    end
  end
end
