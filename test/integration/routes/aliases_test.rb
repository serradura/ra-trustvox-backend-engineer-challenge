require 'test_helper'

class Routes::AliasesTest < ActionDispatch::IntegrationTest
  def application_routes
    @application_routes ||=
      ActionDispatch::Routing::RoutesInspector
        .new(Rails.application.routes.routes)
        .format(ActionDispatch::Routing::ConsoleFormatter.new)
        .split("\n")
  end

  test "POST /complaints" do
    post complaints_url, headers: { 'Content-Type': 'application/json' }

    refute @response.status == 404

    post complaints_url(format: 'json')

    refute @response.status == 404

    #
    # Auditing its controller,
    # because of the path is an alias to other resource.
    #
    assert application_routes
      .find { |r| r.match?(/complaints POST/) }
      .strip
      .ends_with?('complaints/v1/create#call')
  end
end
