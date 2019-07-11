require 'test_helper'

module Complaints
  class V1::FetchControllerTest < ActionDispatch::IntegrationTest
    DeleteAllComplaints = -> { Document.delete_all }

    setup(&DeleteAllComplaints)

    teardown(&DeleteAllComplaints)

    test 'should return "not found" when it has invalid constraints' do
      get v1_complaint_url(create_complaint!.id)

      assert_response :not_found
      assert_response_error 'the requested resource was not found'
    end

    test 'should return "not found" when the document id was not found' do
      get resource_path('dont-find-me')

      assert_response :not_found
      assert_response_error 'complaint not found with id: "dont-find-me"'
    end

    test 'should return "ok" when the document was found' do
      record = create_complaint!

      get resource_path(record.id)

      record_id = record.id.to_s

      expected_json =
        { 'id' => record_id }
          .merge(Fields::ALL.map { |f| [f, record[f]] }.to_h)
          .merge('_links' => [{
            'rel' => 'self',
            'href' => complaint_url(record_id),
            'method' => 'GET'
          }])

      assert_response :ok
      assert_equal expected_json, JSON.parse(@response.body)
    end

    private

    def resource_path(id)
      v1_complaint_url(id, format: 'json')
    end
  end
end
