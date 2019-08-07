# frozen_string_literal: true

module Service
  class Pagy
    class << self
      include ::Pagy::Backend

      def call(collection, page:, items:, **)
        pagy_method = collection.is_a?(Array) ? :pagy_array : :pagy
        send(pagy_method, collection, page: page, items: items)
      end

      private

      define_method(:params) { {} }
    end
  end
end
