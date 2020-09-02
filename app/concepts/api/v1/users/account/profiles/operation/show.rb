# frozen_string_literal: true

module Api::V1::Users::Account::Profiles::Operation
  class Show < ApplicationOperation
    step Macro::Assign.new.call(to: :model, path: %i[current_account user])
    step Macro::Assign.new.call(to: :available_inclusion_options, value: %w[account])
    step Subprocess(Api::V1::Lib::Operation::Inclusion)
    step Macro::Renderer.new.call(serializer: Api::V1::Users::Account::Profiles::Serializer::Show)
  end
end
