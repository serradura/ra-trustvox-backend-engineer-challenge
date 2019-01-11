# frozen_string_literal: true

module Complaints
  module V1
    class FetchController < ApplicationController
      def call
        record = Document.find(params[:id])

        serialize = Serializer.new(Fields::ALL)

        render status: 200, json: serialize.call(record)
      rescue Mongoid::Errors::DocumentNotFound => e
        render status: :not_found, json: {
          error: ["Complaint not found with id: \"#{params[:id]}\""]
        }
      end
    end
  end
end
