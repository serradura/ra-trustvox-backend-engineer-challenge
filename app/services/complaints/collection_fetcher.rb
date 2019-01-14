# frozen_string_literal: true

module Complaints
  class CollectionFetcher < ApplicationService
    def initialize(params, url_builders)
      @fields_to_select = ParseFieldsToSelect.(params[:fields])
      @serialize_document = DocumentSerializer.(url_builders, @fields_to_select)
      @collection_url_builder = url_builders.fetch(:collection)
    end

    def call
      link_to_self =
        HATEOAS::LinkToGet[:self, builder: @collection_url_builder]

      data = serialize(relation).then(&HATEOAS::SetLinks[link_to_self])

      [SUCCESS, data]
    end

    private

    def relation
      criteria = Document.all

      return criteria if @fields_to_select.blank?

      fields = ['_id'] + @fields_to_select

      criteria.only(*fields)
    end

    def serialize(relation)
      relation.each_with_object({}) do |record, memo|
        data = @serialize_document[record]

        memo[data.delete('id')] = data
      end
    end
  end
end
