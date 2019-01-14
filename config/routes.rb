# frozen_string_literal: true

require_relative './routes/json_constraint'

MapV1Resource = -> (only, controller:) do
  {only: only, module: :v1, controller: controller, action: :call}
end

MapBaseResource = -> (only, controller:) do
  { constraints: Routes::JSONConstraint, path: '' }
    .merge!(MapV1Resource[only, controller: controller])
end

Rails.application.routes.draw do
  namespace :v1, module: :complaints, constraints: Routes::JSONConstraint do
    resources :complaints, MapV1Resource[:index, controller: :fetch_all]
    resources :complaints, MapV1Resource[:show, controller: :fetch]
    resources :complaints, MapV1Resource[:create, controller: :create]
  end

  scope :complaints, module: :complaints do
    resources :complaints, MapBaseResource[:index, controller: :fetch_all]
    resources :complaints, MapBaseResource[:show, controller: :fetch]
    resources :complaints, MapBaseResource[:create, controller: :create]
  end

  root to: 'errors/v1/not_found#call', via: :all

  match '*unmatched', to: 'errors/v1/not_found#call', via: :all
end
