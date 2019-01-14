# frozen_string_literal: true

module Complaints
  class CollectionFetcher
    module ParseFieldsToSelect
      extend self

      def call(fields_param)
        filter = map_filter_from(fields_param)

        Fields::ALL
          .filter { |field| filter.include?(field) }
          .then { |fields| Array(fields.presence) }
      end

      private

      def map_filter_from(fields_param)
        String(fields_param)
          .split(',')
          .map(&:downcase)
      end
    end
  end
end
