require 'test_helper'

class Routes::RootPathTest < ActionDispatch::IntegrationTest
  def assert_not_found_response
    expected_body = { 'error' => ['the requested resource was not found'] }

    assert_equal expected_body, JSON.parse(@response.body)
  end

  test '{GET,POST,PUT,PATCH} /' do
    get '/'

    assert_response :not_found
    assert_not_found_response

    post '/'

    assert_response :not_found
    assert_not_found_response

    put '/'

    assert_response :not_found
    assert_not_found_response

    patch '/'

    assert_response :not_found
    assert_not_found_response

    delete '/'

    assert_response :not_found
    assert_not_found_response
  end
end
