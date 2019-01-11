# frozen_string_literal: true

module Routes
  class JSONConstraint
    def self.application_json?(headers)
      headers['CONTENT_TYPE'] == 'application/json'
    end

    def self.matches?(request)
      application_json?(request.headers) || request.format.json?
    end
  end
end
