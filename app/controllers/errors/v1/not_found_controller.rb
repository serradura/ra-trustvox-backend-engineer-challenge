# frozen_string_literal: true

module Errors
  module V1
    class NotFoundController < ApplicationController
      RESULT = Serializer['the requested resource was not found']

      def call
        render status: :not_found, json: RESULT
      end
    end
  end
end
