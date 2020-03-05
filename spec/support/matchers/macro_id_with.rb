# frozen_string_literal: true

RSpec::Matchers.define(:macro_id_with) do |macro_name|
  match { |macro_id| /\Amacro\/#{macro_name}_id_\d+\z/.match?(macro_id) }
end
