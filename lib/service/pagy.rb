# frozen_string_literal: true

module Service
  class Pagy
    class << self
      include ::Pagy::Backend

      def call(collection, page:, items:, **)
        pagy(collection, page: page, items: items)
      end

      private

      define_method(:params) { {} }
    end
  end
end
