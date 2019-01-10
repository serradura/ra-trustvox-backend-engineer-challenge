# frozen_string_literal: true

module Complaints
  class CreateJob < ApplicationJob
    queue_as :default

    def perform(params)
      Document.create(params)
    end
  end
end
