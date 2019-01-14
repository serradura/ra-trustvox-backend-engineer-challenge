# frozen_string_literal: true

require_relative './routes/json_constraint'

Rails.application.routes.draw do
  namespace :v1, constraints: Routes::JSONConstraint do
    resources :complaints, only: %i[index show create]
  end

  resources :complaints, only: %i[index show create],
                         module: :v1,
                         constraints: Routes::JSONConstraint

  root to: 'v1/errors/not_found#show', via: :all

  match '*unmatched', to: 'v1/errors/not_found#show', via: :all
end
