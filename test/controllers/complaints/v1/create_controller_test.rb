require 'test_helper'

module Complaints
  class V1::CreateControllerTest < ActionDispatch::IntegrationTest
    setup do
      @resource_path = v1_complaints_url(format: 'json')
    end

    test 'should return "not found" when it has invalid constraints' do
      post v1_complaints_url

      assert_response :not_found
      assert_response_error 'the requested resource was not found'
    end

    test 'should return a "bad request" when receiving invalid params' do
      #
      # no data
      #
      post @resource_path, params: {}

      assert_response :bad_request
      assert_response_error 'param is missing or the value is empty: complaint'

      #
      # no complaint data
      #
      post @resource_path, params: {
        complaint: {}
      }

      assert_response :bad_request
      assert_response_error 'param is missing or the value is empty: complaint'

      #
      # without the complaint title
      #
      post @resource_path, params: {
        complaint: { locale: 'b', company: 'c', description: 'd'}
      }

      assert_response :bad_request
      assert_response_error 'required params are unfilled: ["title", "locale", "company", "description"]'

      #
      # without the complaint locale
      #
      post @resource_path, params: {
        complaint: { title: 'a', company: 'c', description: 'd'}
      }

      assert_response :bad_request
      assert_response_error 'required params are unfilled: ["title", "locale", "company", "description"]'

      #
      # without the complaint company
      #
      post @resource_path, params: {
        complaint: { title: 'a', locale: 'b', description: 'd'}
      }

      assert_response :bad_request
      assert_response_error 'required params are unfilled: ["title", "locale", "company", "description"]'

      #
      # without the complaint description
      #
      post @resource_path, params: {
        complaint: { title: 'a', locale: 'b', company: 'c'}
      }

      assert_response :bad_request
      assert_response_error 'required params are unfilled: ["title", "locale", "company", "description"]'
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
          post @resource_path, params: {
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
