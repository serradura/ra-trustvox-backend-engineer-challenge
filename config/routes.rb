# frozen_string_literal: true

class JSONConstraint
  def self.application_json?(headers)
    headers['CONTENT_TYPE'] == 'application/json'
  end

  def self.matches?(request)
    application_json?(request.headers) || request.format.json?
  end
end

Rails.application.routes.draw do
  namespace :errors do
    namespace :v1 do
      post :not_found, to: 'not_found#call'
    end
  end

  namespace :complaints, constraints: JSONConstraint do
    namespace :v1 do
      post :create, to: 'create#call'
    end
  end

  match '*unmatched', to: 'errors/v1/not_found#call', via: :all
end
