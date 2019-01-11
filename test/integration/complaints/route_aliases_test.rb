require 'test_helper'

module Complaints
  class RouteAliasesTest < ActionDispatch::IntegrationTest
    test "POST /complaints" do
      post complaints_url, headers: { 'Content-Type': 'application/json' }

      refute @response.status == 404

      post complaints_url(format: 'json')

      refute @response.status == 404

      assert_route('POST /complaints', to: 'complaints/v1/create#call')
    end

    test "GET /complaints" do
      get complaints_url, headers: { 'Content-Type': 'application/json' }

      refute @response.status == 404

      get complaints_url(format: 'json')

      refute @response.status == 404

      assert_route('GET /complaints', to: 'complaints/v1/fetch_all#call')
    end

    private

    def application_routes
      @application_routes ||=
        ActionDispatch::Routing::RoutesInspector
          .new(Rails.application.routes.routes)
          .format(ActionDispatch::Routing::ConsoleFormatter.new)
          .split("\n")
    end

    def assert_route(route_alias, to:)
      route_pattern =
        Regexp.new("#{route_alias.split(/\s+/).join('\s+')}\\(")

      assert application_routes
        .find { |r| r.match?(route_pattern) }
        .strip
        .ends_with?(to)
    end
  end
end
