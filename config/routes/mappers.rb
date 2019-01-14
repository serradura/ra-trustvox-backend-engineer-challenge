# frozen_string_literal: true

module Routes
  require_relative './json_constraint'

  class Mappers
    MapV1Resource = -> (only, controller:) do
      { only: only, module: :v1, controller: controller, action: :call }
    end

    MapBaseResource = -> (only, controller:) do
      { constraints: Routes::JSONConstraint, path: '' }
        .merge!(MapV1Resource[only, controller: controller])
    end
  end
end
