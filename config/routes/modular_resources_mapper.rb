# frozen_string_literal: true

module Routes
  require_relative './mappers'

  module ModularResourcesMapper
    def map_modular_json_resources!(spec)
      spec.each do |version, resource_names|
        resource_names.each do |resource_name, scheme|
          namespace version, module: resource_name, constraints: Routes::JSONConstraint do
            scheme.each do |action, controller|
              resources resource_name, Mappers::MapV1Resource[action, controller: controller]
            end
          end
        end

        resource_names.each do |resource_name, scheme|
          scope resource_name, module: resource_name do
            scheme.each do |action, controller|
              resources resource_name, Mappers::MapBaseResource[action, controller: controller]
            end
          end
        end
      end
    end
  end
end
