require 'test_helper'

module Complaints
  class V1::IndexControllerTest < ActionDispatch::IntegrationTest
    DeleteAllComplaints = -> { Document.delete_all }

    LINK_TO_SELF = {
      "rel" => "self",
      "href" => "http://www.example.com/complaints",
      "method" => "GET"
    }.freeze

    setup(&DeleteAllComplaints)

    teardown(&DeleteAllComplaints)

    test 'should return "not found" when it has invalid constraints' do
      get v1_complaints_url

      assert_response :not_found
      assert_response_error 'the requested resource was not found'
    end

    test 'should return "ok" even there are no complaints' do
      get resource_path

      expected_json = {
        "_links" => [LINK_TO_SELF]
      }

      assert_response :ok
      assert_equal(expected_json, JSON.parse(@response.body))
    end

    test 'should return "ok" when there are complaints' do
      records = 2.times.map { create_complaint! }

      get resource_path

      serialized_records = records.map do |record|
        record_id = record.id.to_s

        { 'id' => record_id }
          .merge(Fields::ALL.map { |f| [f, record[f]] }.to_h)
          .merge('_links' => [{
            'rel' => 'complaint',
            'href' => complaint_url(record_id),
            'method' => 'GET'
          }])
      end

      expected_json =
        serialized_records
          .each_with_object({}) { |rec, memo| memo[rec.delete('id')] = rec }
          .merge!({ "_links" => [LINK_TO_SELF] })

      assert_response :ok
      assert_equal expected_json, JSON.parse(@response.body)
    end

    test 'should return "ok" when receive the fields filter without valid options' do
      records = 2.times.map { create_complaint! }

      get resource_path(format: 'json', fields: 'aaa,bbb')

      serialized_records = records.map do |record|
        record_id = record.id.to_s

        { 'id' => record_id }
          .merge(Fields::ALL.map { |f| [f, record[f]] }.to_h)
          .merge('_links' => [{
            'rel' => 'complaint',
            'href' => complaint_url(record_id),
            'method' => 'GET'
          }])
      end

      expected_json =
        serialized_records
          .each_with_object({}) { |rec, memo| memo[rec.delete('id')] = rec }
          .merge!({ "_links" => [LINK_TO_SELF] })

      assert_response :ok
      assert_equal expected_json, JSON.parse(@response.body)
    end

    test 'should return "ok" when receive the fields filter with valid options' do
      records = 2.times.map { create_complaint! }

      get resource_path(format: 'json', fields: 'title,company')

      serialized_records = records.map do |record|
        record_id = record.id.to_s

        { 'id' => record_id }
          .merge(
            [Fields::TITLE, Fields::COMPANY].map { |f| [f, record[f]] }.to_h
          )
          .merge('_links' => [{
            'rel' => 'complaint',
            'href' => complaint_url(record_id),
            'method' => 'GET'
          }])
      end

      expected_json =
        serialized_records
          .each_with_object({}) { |rec, memo| memo[rec.delete('id')] = rec }
          .merge!({ "_links" => [LINK_TO_SELF] })

      assert_response :ok
      assert_equal expected_json, JSON.parse(@response.body)
    end

    private

    def resource_path(options = {format: 'json'})
      v1_complaints_url(options)
    end
  end
end
