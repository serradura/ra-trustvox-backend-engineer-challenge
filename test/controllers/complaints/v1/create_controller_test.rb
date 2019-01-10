require 'test_helper'

module Complaints
  class V1::CreateControllerTest < ActionDispatch::IntegrationTest
    test 'should return "not found" when is an invalid path' do
      post complaints_v1_create_url

      assert_response :not_found
    end

    test 'should not returns "not found" when resolving its constraints' do
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

      #
      # no complaint data
      #
      post complaints_v1_create_url(format: 'json'), params: {
        complaint: {}
      }

      assert_response :bad_request

      #
      # without the complaint title
      #
      post complaints_v1_create_url(format: 'json'), params: {
        complaint: { locale: 'b', company: 'c', description: 'd'}
      }

      assert_response :bad_request

      #
      # without the complaint locale
      #
      post complaints_v1_create_url(format: 'json'), params: {
        complaint: { title: 'a', company: 'c', description: 'd'}
      }

      assert_response :bad_request

      #
      # without the complaint company
      #
      post complaints_v1_create_url(format: 'json'), params: {
        complaint: { title: 'a', locale: 'b', description: 'd'}
      }

      assert_response :bad_request

      #
      # without the complaint description
      #
      post complaints_v1_create_url(format: 'json'), params: {
        complaint: { title: 'a', locale: 'b', company: 'c'}
      }

      assert_response :bad_request
    end

    test 'should return "accepted" when receiving valid params' do
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

        assert_response :accepted

        #
        # teardown
        #
        Document.delete_all
        ActiveJob::Base.queue_adapter = queue_adapter
      end
    end
  end
end
