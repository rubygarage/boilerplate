# frozen_string_literal: true

require 'reform'
# require 'reform/form/dry'
require 'reform/form/coercion'

# Reform::Form.class_eval do
#   feature Reform::Form::Dry
# end

module PatchErrorCompiler
  def call(fields, reform_errors, form)
    @validator.with(form: form).call(fields).errors.each do |field, dry_error|
      dry_error.each do |attr_error|
        reform_errors.add(field, attr_error)
      end
    end
  end
end

# Reform::Form::Dry::Validations::Group.prepend(PatchErrorCompiler)
