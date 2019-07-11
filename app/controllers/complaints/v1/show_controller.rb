# frozen_string_literal: true

module Complaints
  module V1
    class ShowController < ApplicationController
      def call
        url_builder = method(:complaint_url)

        result, data = ResourceFetcher.new(params[:id], url_builder).call

        case result
        when ResourceFetcher::SUCCESS then render status: 200, json: data
        when ResourceFetcher::FAILURE then render status: 404, json: data
        else raise NotImplementedError
        end
      end
    end
  end
end
