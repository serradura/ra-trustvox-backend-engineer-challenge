require 'test_helper'

module Complaints
  class CreateJobTest < ActiveJob::TestCase
    test 'that complaint was persisted' do
      assert_enqueued_with(job: CreateJob) do
        CreateJob.perform_later title: 'title',
                                locale: 'locale',
                                company: 'company',
                                description: 'description'
      end
    end

    test "that complaint wasn't persisted" do
      assert_no_changes -> { Document.count } do
        CreateJob.perform_now({})
      end
    end
  end
end
