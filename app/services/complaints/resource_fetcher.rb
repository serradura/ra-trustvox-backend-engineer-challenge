# frozen_string_literal: true

module Complaints
  class ResourceFetcher < ApplicationService
    Serialize = Serializer.new(Fields::ALL)

    def initialize(resource_id,
                   url_builder,
                   error_serializer = Errors::Serializer)
      @resource_id = resource_id
      @url_builder = url_builder
      @error_serializer = error_serializer
    end

    def call
      [SUCCESS, serialize_record]
    rescue Mongoid::Errors::DocumentNotFound
      message = "complaint not found with id: \"#{@resource_id}\""

      [FAILURE, @error_serializer.call(message)]
    end

    private

    def serialize_record
      Document
        .find(@resource_id)
        .then(&Serialize)
        .then(&HATEOAS::SetLinks[link_to_complaint])
    end

    def link_to_complaint
      HATEOAS::LinkToGet[:self, builder: @url_builder]
    end
  end
end
