# frozen_string_literal: true

require_relative './routes/json_constraint'
require_relative './routes/mappers'

Rails.application.routes.draw do
  map_v1_resource = Routes::Mappers::MapV1Resource
  map_base_resource = Routes::Mappers::MapBaseResource

  namespace :v1, module: :complaints, constraints: Routes::JSONConstraint do
    resources :complaints, map_v1_resource[:index, controller: :fetch_all]
    resources :complaints, map_v1_resource[:show, controller: :fetch]
    resources :complaints, map_v1_resource[:create, controller: :create]
  end

  scope :complaints, module: :complaints do
    resources :complaints, map_base_resource[:index, controller: :fetch_all]
    resources :complaints, map_base_resource[:show, controller: :fetch]
    resources :complaints, map_base_resource[:create, controller: :create]
  end

  root to: 'errors/v1/not_found#call', via: :all

  match '*unmatched', to: 'errors/v1/not_found#call', via: :all
end
