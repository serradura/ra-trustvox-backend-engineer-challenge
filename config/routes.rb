# frozen_string_literal: true

require_relative './routes/json_constraint'
require_relative './routes/mappers'

Rails.application.routes.draw do
  map_v1_resource = Routes::Mappers::MapV1Resource
  map_base_resource = Routes::Mappers::MapBaseResource

  {
    v1: {
      complaints: {
        index: :fetch_all,
        show: :fetch,
        create: :create
      }
    }
  }.each do |version, resource_names|
    resource_names.each do |resource_name, scheme|
      namespace version, module: resource_name, constraints: Routes::JSONConstraint do
        scheme.each do |action, controller|
          resources resource_name, map_v1_resource[action, controller: controller]
        end
      end
    end

    resource_names.each do |resource_name, scheme|
      scope resource_name, module: resource_name do
        scheme.each do |action, controller|
          resources resource_name, map_base_resource[action, controller: controller]
        end
      end
    end
  end

  root to: 'errors/v1/not_found#call', via: :all

  match '*unmatched', to: 'errors/v1/not_found#call', via: :all
end
