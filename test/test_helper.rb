ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

class ActiveSupport::TestCase
  def assert_response_error(message)
    expected_body = { 'error' => [message] }

    assert_equal expected_body, JSON.parse(@response.body)
  end
end
