# frozen_string_literal: true

FactoryBot.define do
  factory :setting do
    key { FFaker::Lorem.word }
    value { FFaker::Lorem.word }
  end
end
