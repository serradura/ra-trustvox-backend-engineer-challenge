require 'test_helper'

class Routes::RootPathTest < ActionDispatch::IntegrationTest
  setup do
    @message = 'the requested resource was not found'
  end

  test '{GET,POST,PUT,PATCH,DELETE} /' do
    get '/'

    assert_response :not_found
    assert_response_error(@message)

    post '/'

    assert_response :not_found
    assert_response_error(@message)

    put '/'

    assert_response :not_found
    assert_response_error(@message)

    patch '/'

    assert_response :not_found
    assert_response_error(@message)

    delete '/'

    assert_response :not_found
    assert_response_error(@message)
  end
end
