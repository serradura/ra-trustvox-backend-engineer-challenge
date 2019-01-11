require 'test_helper'

class RoutesTest < ActionDispatch::IntegrationTest
  test "POST /complaints" do
    post complaints_url, headers: { 'Content-Type': 'application/json' }

    refute @response.status == 404

    post complaints_url(format: 'json')

    refute @response.status == 404
  end
end
