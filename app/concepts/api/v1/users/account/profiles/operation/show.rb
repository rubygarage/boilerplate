# frozen_string_literal: true

module Api::V1::Users::Account::Profiles::Operation
  class Show < ApplicationOperation
    step Macro::Assign(to: :model, path: %i[current_account user])
    step Macro::Assign(to: :available_inclusion_options, value: %w[account])
    step Subprocess(Api::V1::Lib::Operation::Inclusion), fast_track: true
    step Macro::Renderer(serializer: Api::V1::Users::Account::Profiles::Serializer::Show)
  end
end
