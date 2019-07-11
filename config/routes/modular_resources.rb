# frozen_string_literal: true

module Routes
  module ModularResources
    MapCallableResource = -> (action, options) do
      {
        only: action,
        module: options.fetch(:module),
        action: :call,
        controller: action
      }.merge(options.key?(:path) ? options.slice(:path) : {})
    end

    class NamespaceMapper
      def initialize(routes, name, mod)
        @routes = routes
        @name = name
        @mod = mod
      end

      def modular_resources(options)
        resource_options = { module: @mod }

        Array(options.fetch(:only)).each do |action|
          @routes.resources @name, MapCallableResource[action, resource_options]
        end
      end
    end

    def modular_resources(name, options)
      resource_options = options.merge(path: '')

      scope name, module: name, constraints: options.fetch(:constraints) do
        Array(options.fetch(:only)).each do |action|
          resources name, MapCallableResource[action, resource_options]
        end
      end
    end

    def modular_namespace(names, constraints:, &block)
      mod, name = Array(names)

      namespace mod, module: name, constraints: constraints do
        NamespaceMapper.new(self, name, mod).instance_eval(&block)
      end
    end

    private_constant :MapCallableResource, :NamespaceMapper
  end
end
