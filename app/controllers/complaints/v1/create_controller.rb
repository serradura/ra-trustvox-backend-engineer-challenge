# frozen_string_literal: true

module Complaints
  module V1
    class CreateController < ApplicationController
      UNFILLED_REQUIRED_PARAMS = Errors::Serializer.call(
        "required params are unfilled: #{Complaints::Fields::ALL}"
      )

      rescue_from ActionController::ParameterMissing,
                  with: Errors::ExceptionHandlers::ParameterMissing

      def call
        result = Creator.new(resource_params).call

        case result
        when Creator::SUCCESS then render status: :no_content
        when Creator::FAILURE then render_bad_request(UNFILLED_REQUIRED_PARAMS)
        else raise NotImplementedError
        end
      end

      private

      def resource_params
        @resource_params ||= params.require(:complaint)
                                   .permit(*Complaints::Fields::ALL)
      end

      def render_bad_request(data)
        render status: :bad_request, json: data
      end
    end
  end
end
