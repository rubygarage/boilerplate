# frozen_string_literal: true

Ransack.configure do |config|
  config.add_predicate 'date_equals',
                       arel_predicate: 'eq',
                       formatter: proc(&:to_date),
                       validator: proc(&:present?),
                       type: :string
end
