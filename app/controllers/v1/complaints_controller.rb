# frozen_string_literal: true

module V1
  class ComplaintsController < ApplicationController
    UNFILLED_REQUIRED_PARAMS = ::Errors::Serializer.call(
      "required params are unfilled: #{Complaints::Fields::ALL}"
    )

    Creator = ::Complaints::Creator
    ResourceFetcher = ::Complaints::ResourceFetcher
    CollectionFetcher = ::Complaints::CollectionFetcher

    rescue_from ActionController::ParameterMissing,
                with: Errors::ExceptionHandlers::ParameterMissing

    def index
      permitted_params = params.permit(:fields)

      collection_fetcher =
        CollectionFetcher.new(permitted_params, url_builders)

      result, data = collection_fetcher.call

      case result
      when CollectionFetcher::SUCCESS then render status: 200, json: data
      else raise NotImplementedError
      end
    end

    def show
      resource_fetcher =
        ResourceFetcher.new(params[:id], url_builders[:resource])

      result, data = resource_fetcher.call

      case result
      when ResourceFetcher::SUCCESS then render status: 200, json: data
      when ResourceFetcher::FAILURE then render status: 404, json: data
      else raise NotImplementedError
      end
    end

    def create
      resource_params =
        params.require(:complaint).permit(*Complaints::Fields::ALL)

      result = Creator.new(resource_params).call

      case result
      when Creator::SUCCESS then render status: :no_content
      when Creator::FAILURE then render_bad_request(UNFILLED_REQUIRED_PARAMS)
      else raise NotImplementedError
      end
    end

    private

    def render_bad_request(data)
      render status: :bad_request, json: data
    end

    def url_builders
      {
        resource: method(:complaint_url),
        collection: method(:complaints_url)
      }
    end
  end
end
