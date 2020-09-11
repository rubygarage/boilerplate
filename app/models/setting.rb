# frozen_string_literal: true

class Setting < ApplicationRecord
  validates :key, presence: true, uniqueness: { case_sensitive: false }
  validates :value, presence: true
end
