# frozen_string_literal: true

module Service
  module JsonApi
    module ErrorDataStructureParser
      private

      def plain_errors?(errors)
        errors.all? { |error| error.is_a?(String) }
      end

      def compose_errors(field, messages)
        { source: { pointer: "/#{field}" }, detail: messages.join(', ') }
      end

      def parse_nested_errors_hash(errors_hash, pointer, memo)
        errors_hash.each do |key, error|
          new_pointer = "#{pointer}/#{key}"

          if error.is_a?(Hash)
            parse_nested_errors_hash(error, new_pointer, memo)
          else
            memo << compose_errors(new_pointer, error)
          end
        end
      end

      def parse_nested_errors_arrays_array(errors_arrays_array, pointer, memo)
        errors_arrays_array.each do |errors_array|
          new_pointer = "#{pointer}/#{errors_array.first}"
          nested_errors = errors_array.second

          if plain_errors?(nested_errors)
            memo << compose_errors(new_pointer, nested_errors)
          else
            parse_nested_errors_hash(nested_errors, new_pointer, memo)
          end
        end
      end

      def parse_errors
        errors.each_with_object([]) do |(field, error_value), memo|
          if plain_errors?(error_value)
            memo << compose_errors(field, error_value)
          else
            parse_nested_errors_arrays_array(error_value, field, memo)
          end
        end
      end
    end
  end
end
