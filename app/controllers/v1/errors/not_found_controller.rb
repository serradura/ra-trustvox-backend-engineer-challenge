# frozen_string_literal: true

module V1::Errors
  class NotFoundController < ApplicationController
    RESULT = ::Errors::Serializer['the requested resource was not found']

    def show
      render status: :not_found, json: RESULT
    end
  end
end
