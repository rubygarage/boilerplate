# frozen_string_literal: true

module JsonApi
  module Filtering
    module Operators
      MATCH_ALL = 'all_filters'
      MATCH_ANY = 'any_filters'
    end

    OPERATORS = [Operators::MATCH_ALL, Operators::MATCH_ANY].freeze

    module Predicates
      EQUAL = 'eq'
      EQUAL_RELATIVE = 'eq_rel'
      NOT_EQUAL = 'not_eq'
      NOT_EQUAL_RELATIVE = 'not_eq_rel'
      CONTAINS = 'cont'
      NOT_CONTAINS = 'not_cont'
      GREATER_THAN = 'gt'
      GREATER_THAN_OR_EQUAL = 'gteq'
      LESS_THAN = 'lt'
      TRUE = 'true'
      FALSE = 'false'
      NULL = 'null'
      NOT_NULL = 'not_null'
      GREATER_THAN_RELATIVE = 'gt_rel'
      LESS_THAN_RELATIVE = 'lt_rel'
    end

    PREDICATES = {
      string: [
        Predicates::EQUAL,
        Predicates::NOT_EQUAL,
        Predicates::CONTAINS,
        Predicates::NOT_CONTAINS
      ].to_set,
      number: [
        Predicates::EQUAL,
        Predicates::NOT_EQUAL,
        Predicates::GREATER_THAN,
        Predicates::GREATER_THAN_OR_EQUAL,
        Predicates::NULL,
        Predicates::NOT_NULL
      ].to_set,
      boolean: [
        Predicates::TRUE,
        Predicates::FALSE
      ].to_set,
      date: [
        Predicates::EQUAL,
        Predicates::NOT_EQUAL,
        Predicates::GREATER_THAN,
        Predicates::LESS_THAN,
        Predicates::EQUAL_RELATIVE,
        Predicates::NOT_EQUAL_RELATIVE,
        Predicates::GREATER_THAN_RELATIVE,
        Predicates::LESS_THAN_RELATIVE,
        Predicates::NULL,
        Predicates::NOT_NULL
      ].to_set
    }.freeze
  end
end
