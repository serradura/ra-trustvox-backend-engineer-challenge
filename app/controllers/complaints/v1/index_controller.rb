# frozen_string_literal: true

module Complaints
  module V1
    class IndexController < ApplicationController
      def call
        link_to_self =
          HATEOAS::LinkToGet[:self, builder: method(:complaints_url)]

        data = fetch_data.then(&HATEOAS::SetLinks[link_to_self])

        render status: 200, json: data
      end

      private

      def permitted_params
        params.permit(:fields)
      end

      def fields_to_select
        @fields_to_select ||= begin
          fields =
            String(permitted_params[:fields]).split(',').map(&:downcase)

          Fields::ALL
            .filter { |field| fields.include?(field) }
            .then { |filtered| filtered if filtered.present? }
            .then { |result| Array(result) }
        end
      end

      def fetch_relation
        criteria = Document.all

        return criteria if fields_to_select.blank?

        fields = ['_id'] + fields_to_select

        criteria.only(*fields)
      end

      def fetch_data
        serialize =
          Serializer.new(fields_to_select.presence || Fields::ALL)

        link_to_complaint =
          HATEOAS::LinkToGet[:complaint, builder: method(:complaint_url)]

        serialize_document =
          serialize >> HATEOAS::SetLinks[link_to_complaint]

        fetch_relation.each_with_object({}) do |record, memo|
          data = serialize_document[record]

          memo[data.delete('id')] = data
        end
      end
    end
  end
end
