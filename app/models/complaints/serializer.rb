# frozen_string_literal: true

module Complaints
  class Serializer
    def initialize(fields)
      @fields = fields
    end

    def call(record)
      { id: record.id.to_s }
        .merge! map_fields_values(record)
    end

    def to_proc
      @to_proc ||= -> record { call(record) }
    end

    private

    def map_fields_values(record)
      @fields.each_with_object({}) do |field, data|
        value = record[field]

        data[field] = value if value.present?
      end
    end
  end
end
