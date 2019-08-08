# frozen_string_literal: true

module Service
  module JsonApi
    class Paginator
      QUERY_PAGE_PARAMETER = 'page[number]'

      class << self
        def call(resource_path:, pagy:)
          {
            self: page_path(resource_path, pagy.page),
            first: resource_path,
            next: page_path(resource_path, pagy.next),
            prev: page_path(resource_path, pagy.prev),
            last: page_path(resource_path, pagy.pages)
          }
        end

        private

        def page_path(resource_path, page)
          return if page.blank?

          "#{resource_path}?#{QUERY_PAGE_PARAMETER}=#{page}"
        end
      end
    end
  end
end
