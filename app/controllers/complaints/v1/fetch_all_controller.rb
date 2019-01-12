# frozen_string_literal: true

module Complaints
  module V1
    class FetchAllController < ApplicationController
      def call
        render status: 200, json: fetch_data
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
          HATEOAS::LinkToGet[:complaint, builder: method(:complaints_show_url)]

        fetch_relation.map(&serialize >> HATEOAS::Links[link_to_complaint])
      end
    end
  end
end
