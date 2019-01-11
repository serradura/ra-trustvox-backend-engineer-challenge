require 'test_helper'

module Complaints
  class V1::CreateControllerTest < ActionDispatch::IntegrationTest
    def assert_response_error(message)
      expected_body = { 'error' => [message] }

      assert JSON.parse(@response.body) == expected_body
    end

    test 'should return "not found" when is has invalid constraints' do
      post complaints_v1_create_url

      assert_response :not_found
      assert_response_error 'the requested resource was not found'
    end

    test 'should not returns "not found" when has valid constraints' do
      post complaints_v1_create_url, headers: { 'Content-Type': 'application/json' }

      refute @response.status == 404

      post complaints_v1_create_url(format: 'json')

      refute @response.status == 404
    end

    test 'should return a "bad request" when receiving invalid params' do
      #
      # no data
      #
      post complaints_v1_create_url(format: 'json'), params: {}

      assert_response :bad_request
      assert_response_error 'param is missing or the value is empty: complaint'

      #
      # no complaint data
      #
      post complaints_v1_create_url(format: 'json'), params: {
        complaint: {}
      }

      assert_response :bad_request
      assert_response_error 'param is missing or the value is empty: complaint'

      #
      # without the complaint title
      #
      post complaints_v1_create_url(format: 'json'), params: {
        complaint: { locale: 'b', company: 'c', description: 'd'}
      }

      assert_response :bad_request
      assert_response_error 'invalid parameters was found'

      #
      # without the complaint locale
      #
      post complaints_v1_create_url(format: 'json'), params: {
        complaint: { title: 'a', company: 'c', description: 'd'}
      }

      assert_response :bad_request
      assert_response_error 'invalid parameters was found'

      #
      # without the complaint company
      #
      post complaints_v1_create_url(format: 'json'), params: {
        complaint: { title: 'a', locale: 'b', description: 'd'}
      }

      assert_response :bad_request
      assert_response_error 'invalid parameters was found'

      #
      # without the complaint description
      #
      post complaints_v1_create_url(format: 'json'), params: {
        complaint: { title: 'a', locale: 'b', company: 'c'}
      }

      assert_response :bad_request
      assert_response_error 'invalid parameters was found'
    end

    test 'should return "204 - no content" when receiving valid params' do
      ActiveJob::Base.queue_adapter.tap do |queue_adapter|
        #
        # setup
        #
        ActiveJob::Base.queue_adapter = :inline

        #
        # assertions
        #
        assert_changes -> { Document.count } do
          post complaints_v1_create_url(format: 'json'), params: {
            complaint: { title: 'a', locale: 'b', company: 'c', description: 'd'}
          }
        end

        assert_response :no_content

        #
        # teardown
        #
        Document.delete_all
        ActiveJob::Base.queue_adapter = queue_adapter
      end
    end
  end
end
