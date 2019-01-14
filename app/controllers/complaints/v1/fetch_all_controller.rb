# frozen_string_literal: true

module Complaints
  module V1
    class FetchAllController < ApplicationController
      def call
        result, data = collection_fetcher.call

        case result
        when CollectionFetcher::SUCCESS then render status: 200, json: data
        else raise NotImplementedError
        end
      end

      private

      def permitted_params
        params.permit(:fields)
      end

      def collection_fetcher
        url_builders = {
          resource: method(:complaints_item_url),
          collection: method(:complaints_url)
        }

        CollectionFetcher.new(permitted_params, url_builders)
      end
    end
  end
end
