# frozen_string_literal: true

module Macro
  module Contract
    def self.Schema(schema, name: 'default', inject: [])
      schema_object_class = BaseSchemaObject.Build(schema)

      step = ->(ctx, **) {
        dependencies = inject.each_with_object({}) { |option, memo| memo[option] = ctx[option] }
        ctx["contract.#{name}"] = schema_object_class.new(schema, dependencies)
      }

      task = Trailblazer::Activity::TaskBuilder::Binary(step)
      { task: task, id: "contract.#{name}.build_schema_id#{task.object_id}" }
    end

    class BaseSchemaObject
      attr_reader :schema, :result, :dependencies
      delegate :errors, to: :result

      def self.Build(schema)
        Class.new(self) do
          schema.rules.each_key do |key|
            attr_reader key

            define_method("#{key}=") do |value|
              normalized_value =
                case value
                when Hash, Array then JSON.parse(value.to_json, object_class: NullStruct)
                else value
                end

              instance_variable_set("@#{key}", normalized_value)
            end
          end
        end
      end

      def initialize(schema, dependencies)
        @schema = build_schema(schema, dependencies)
      end

      def call(params)
        result = schema.call(params)
        assign_values(result.output) if result.success?
        @result = SchemaResult.new(result)
      end

      private

      def build_schema(schema, dependencies)
        return schema if dependencies.empty?

        schema.with(dependencies)
      end

      def assign_values(values)
        schema.rules.each_key do |key|
          public_send("#{key}=", values[key])
        end
      end

      class NullStruct < OpenStruct
        def respond_to_missing?(*)
          true
        end

        def method_missing(*) # rubocop:disable Style/MethodMissingSuper
          nil
        end
      end

      class SchemaResult
        def initialize(result)
          @result = result
          compose_errors
        end

        def success?
          !(result.failure? || errors.messages.present?)
        end

        def errors
          @errors ||= Reform::Contract::Errors.new
        end

        private

        attr_reader :result

        def compose_errors
          result.errors.each do |field, messages|
            messages.each { |message| errors.add(field, message) }
          end
        end
      end
    end
  end
end
