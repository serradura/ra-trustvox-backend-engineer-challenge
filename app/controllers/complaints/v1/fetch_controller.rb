# frozen_string_literal: true

module Complaints
  module V1
    class FetchController < ApplicationController
      rescue_from Mongoid::Errors::DocumentNotFound do
        result =
          Errors::Serializer["complaint not found with id: \"#{params[:id]}\""]

        render status: :not_found, json: result
      end

      def call
        record = Document.find(params[:id])

        link_to_complaint =
          HATEOAS::LinkToGet[:self, builder: method(:complaints_show_url)]

        serialize =
          Serializer.new(Fields::ALL) >> HATEOAS::Links[link_to_complaint]

        render status: 200, json: serialize[record]
      end
    end
  end
end
