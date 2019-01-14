# frozen_string_literal: true

module Complaints
  class CollectionFetcher
    module DocumentSerializer
      extend self

      def call(url_builders, fields_to_select)
        link_to_complaint =
          HATEOAS::LinkToGet[:complaint, builder: url_builders.fetch(:resource)]

        Serializer
          .new(fields_to_select.presence || Fields::ALL)
          .>>(HATEOAS::SetLinks[link_to_complaint])
      end
    end
  end
end
