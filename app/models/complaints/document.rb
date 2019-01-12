# frozen_string_literal: true

module Complaints
  class Document
    include Mongoid::Document

    field Fields::TITLE, type: String
    field Fields::LOCALE, type: String
    field Fields::COMPANY, type: String
    field Fields::DESCRIPTION, type: String

    validates(*Fields::ALL, presence: true)
  end
end
