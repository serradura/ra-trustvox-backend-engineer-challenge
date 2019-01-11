# frozen_string_literal: true

module Complaints
  module V1
    class CreateController < ApplicationController
      rescue_from ActionController::ParameterMissing,
                  with: ExceptionHandlers::ParameterMissing

      FIELDS = Document.fields.keys.reject { |field| field == '_id' }

      def call
        if invalid_params?
          render status: :bad_request,
                 json: { error: ['invalid parameters was found'] }
        else
          create_later!

          render status: :no_content
        end
      end

      private

      def resource_params
        @resource_params ||= params.require(:complaint).permit(*FIELDS)
      end

      def invalid_params?
        return true if resource_params.empty?

        FIELDS.any? { |field| resource_params[field].nil? }
      end

      def create_later!
        CreateJob.perform_later(resource_params.as_json)
      end
    end
  end
end
