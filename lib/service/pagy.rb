# frozen_string_literal: true

module Service
  class Pagy
    class << self
      include ::Pagy::Backend

      def call(collection, page:, items:, elastic_collection:, **)
        pagy_method = elastic_collection ? :pagy_searchkick : :pagy
        send(pagy_method, collection, page: page, items: items)
      end

      private

      define_method(:params) { {} }
    end
  end
end
