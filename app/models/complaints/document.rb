# frozen_string_literal: true

module Complaints
  class Document
    include Mongoid::Document

    field :title, type: String
    field :locale, type: String
    field :company, type: String
    field :description, type: String

    validates :title, :locale, :company, :description, presence: true
  end
end
