# frozen_string_literal: true

module Service
  module JsonApi
    class ResourceSerializer
      private_class_method :new

      def self.call(result)
        new(result).call
      end

      def initialize(result)
        renderer = result[:renderer]
        @serializer = renderer.delete(:serializer)
        @options = renderer
        @object = result[:model]
      end

      def call
        serializer.new(object, options)
      end

      private

      attr_reader :serializer, :options, :object
    end
  end
end
