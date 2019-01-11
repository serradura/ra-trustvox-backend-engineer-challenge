# frozen_string_literal: true

module Errors
  module V1
    class NotFoundController < ApplicationController
      MESSAGE = 'the requested resource was not found'

      def call
        render status: :not_found, json: { error: [MESSAGE] }
      end
    end
  end
end
