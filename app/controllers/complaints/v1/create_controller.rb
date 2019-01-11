# frozen_string_literal: true

module Complaints
  module V1
    class CreateController < ApplicationController
      UNFILLED_REQUIRED_PARAMS_ERROR =
        "required params are unfilled: #{Complaints::Fields::ALL}"

      rescue_from ActionController::ParameterMissing,
                  with: ExceptionHandlers::ParameterMissing

      def call
        if unfilled_required_params?
          render status: :bad_request,
                 json: { error: [UNFILLED_REQUIRED_PARAMS_ERROR]}
        else
          create_later!

          render status: :no_content
        end
      end

      private

      def resource_params
        @resource_params ||= params.require(:complaint)
                                   .permit(*Complaints::Fields::ALL)
      end

      def unfilled_required_params?
        return true if resource_params.empty?

        Complaints::Fields::ALL.any? { |field| resource_params[field].nil? }
      end

      def create_later!
        CreateJob.perform_later(resource_params.as_json)
      end
    end
  end
end
