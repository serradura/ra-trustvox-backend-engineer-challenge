require 'test_helper'

module Complaints
  class V1::FetchAllControllerTest < ActionDispatch::IntegrationTest
    DeleteAllComplaints = -> { Document.delete_all }

    setup(&DeleteAllComplaints)

    teardown(&DeleteAllComplaints)

    test 'should return "not found" when it has invalid constraints' do
      get complaints_v1_fetch_all_url

      assert_response :not_found
      assert_response_error 'the requested resource was not found'
    end

    test 'should return "ok" even there are no complaints' do
      get resource_path

      assert_response :ok
      assert_equal([], JSON.parse(@response.body))
    end

    test 'should return "ok" when there are complaints' do
      records = 2.times.map { create_complaint! }

      get resource_path

      expected_json = records.map do |record|
        record_id = record.id.to_s

        { 'id' => record_id }
          .merge(Fields::ALL.map { |f| [f, record[f]] }.to_h)
          .merge('_links' => [{
            'rel' => 'complaint',
            'href' => complaints_show_url(record_id),
            'type' => 'GET'
          }])
      end

      assert_response :ok
      assert_equal expected_json, JSON.parse(@response.body)
    end

    test 'should return "ok" when receive the fields filter without valid options' do
      records = 2.times.map { create_complaint! }

      get resource_path(format: 'json', fields: 'aaa,bbb')

      expected_json = records.map do |record|
        record_id = record.id.to_s

        { 'id' => record_id }
          .merge(Fields::ALL.map { |f| [f, record[f]] }.to_h)
          .merge('_links' => [{
            'rel' => 'complaint',
            'href' => complaints_show_url(record_id),
            'type' => 'GET'
          }])
      end

      assert_response :ok
      assert_equal expected_json, JSON.parse(@response.body)
    end

    test 'should return "ok" when receive the fields filter with valid options' do
      records = 2.times.map { create_complaint! }

      get resource_path(format: 'json', fields: 'title,company')

      expected_json = records.map do |record|
        record_id = record.id.to_s

        { 'id' => record_id }
          .merge(
            [Fields::TITLE, Fields::COMPANY].map { |f| [f, record[f]] }.to_h
          )
          .merge('_links' => [{
            'rel' => 'complaint',
            'href' => complaints_show_url(record_id),
            'type' => 'GET'
          }])
      end

      assert_response :ok
      assert_equal expected_json, JSON.parse(@response.body)
    end

    private

    def resource_path(options = {format: 'json'})
      complaints_v1_fetch_all_url(options)
    end
  end
end
