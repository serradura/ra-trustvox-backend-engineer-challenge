# frozen_string_literal: true

module Errors
  module V1
    class NotFoundController < ApplicationController
      def call
        render status: :not_found, json: { error: 'No route found' }
      end
    end
  end
end
