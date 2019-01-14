# frozen_string_literal: true

module Complaints
  class Creator < ApplicationService
    def initialize(params)
      @params = params
    end

    def call
      return FAILURE if some_required_param_unfilled?

      create_later!
        .then { SUCCESS }
    end

    private

    def some_required_param_unfilled?
      @params.empty? || Fields::ALL.any? do |field|
        @params[field].nil?
      end
    end

    def create_later!
      CreateJob.perform_later(@params.as_json)
    end
  end
end
