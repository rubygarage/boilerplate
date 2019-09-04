# frozen_string_literal: true

module Api::V1::Users::ResetPasswords::Operation
  class Show < ApplicationOperation
    step Subprocess(Api::V1::Users::Lib::Operation::DecryptEmailToken), fast_track: true
    step Subprocess(Api::V1::Users::Lib::Operation::CheckEmailTokenRedisEquality), fast_track: true
  end
end
