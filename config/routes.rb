# frozen_string_literal: true

require_relative './routes/modular_resources_mapper'

Rails.application.routes.draw do
  extend Routes::ModularResourcesMapper

  map_modular_json_resources!(
    v1: {
      complaints: {
        index: :fetch_all,
        show: :fetch,
        create: :create
      }
    }
  )

  root to: 'errors/v1/not_found#call', via: :all

  match '*unmatched', to: 'errors/v1/not_found#call', via: :all
end
