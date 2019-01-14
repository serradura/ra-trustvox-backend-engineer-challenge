# frozen_string_literal: true

require_relative './routes/json_constraint'
require_relative './routes/modular_resources'

Rails.application.routes.draw do
  extend Routes::ModularResources

  modular_namespace [:v1, :complaints], constraints: Routes::JSONConstraint do
    modular_resources only: %i[index show create]
  end

  modular_resources :complaints, only: %i[index show create],
                                 module: :v1,
                                 constraints: Routes::JSONConstraint

  root to: 'errors/v1/not_found#call', via: :all

  match '*unmatched', to: 'errors/v1/not_found#call', via: :all
end
