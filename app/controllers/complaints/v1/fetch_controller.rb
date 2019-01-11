# frozen_string_literal: true

module Complaints
  module V1
    class FetchController < ApplicationController
      def call
        result = map_complaint_data(record: find_record, fields: Fields::ALL)

        render status: 200, json: result
      rescue Mongoid::Errors::DocumentNotFound => e
        render status: :not_found, json: {
          error: ["Complaint not found with id: \"#{params[:id]}\""]
        }
      end

      private

      def find_record
        Document.find(params[:id])
      end

      def map_complaint_data(record:, fields:)
        { id: record.id.to_s }.tap do |result|
          fields.each do |field|
            value = record[field]

            result[field] = value if value.present?
          end
        end
      end
    end
  end
end
