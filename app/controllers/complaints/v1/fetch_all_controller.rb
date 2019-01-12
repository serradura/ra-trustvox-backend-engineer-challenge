# frozen_string_literal: true

module Complaints
  module V1
    class FetchAllController < ApplicationController
      def call
        render status: 200, json: fetch_data
      end

      private

      def fetch_relation
        Document.all
      end

      def fetch_data
        serialize =
          Serializer.new(Fields::ALL)

        link_to_complaint =
          HATEOAS::LinkToGet[:complaint, builder: method(:complaints_show_url)]

        fetch_relation.map(&serialize >> HATEOAS::Links[link_to_complaint])
      end
    end
  end
end
