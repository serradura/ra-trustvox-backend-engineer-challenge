# frozen_string_literal: true

module Complaints
  module V1
    class FetchAllController < ApplicationController
      def call
        render status: 418, json: {}
      end
    end
  end
end
