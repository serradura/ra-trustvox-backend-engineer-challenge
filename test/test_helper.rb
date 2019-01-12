require 'simplecov'
SimpleCov.start

ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

class ActiveSupport::TestCase
  def assert_response_error(message)
    expected_body = { 'error' => [message] }

    assert_equal expected_body, JSON.parse(@response.body)
  end

  def build_complaint_attributes
    Complaints::Fields::ALL
      .map { |f| [f, SecureRandom.alphanumeric(10)] }
      .to_h
  end

  def create_complaint!(attributes = {})
    data = build_complaint_attributes.merge(attributes)

    Complaints::Document.create(data)
  end
end
