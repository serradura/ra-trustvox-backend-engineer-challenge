require 'test_helper'

module Complaints
  class DocumentTest < ActiveSupport::TestCase
    module CheckFieldPresenceValidation
      Result = Struct.new(:error) do
        def has_an_error?; error.present?; end
      end

      def self.of(document)
        errors = document.tap(&:valid?).errors

        -> field { Result.new(errors[field]) }
      end
    end

    test 'validations' do
      document = Complaints::Document.new

      CheckFieldPresenceValidation.of(document)
        .then do |field|
          assert %i[title description locale company]
            .map(&field)
            .all?(&:has_an_error?)
        end

      #
      # title is present
      #
      document.title = 'title'

      CheckFieldPresenceValidation.of(document)
        .then do |field|
          refute field[:title].has_an_error?

          assert field[:description].has_an_error?
          assert field[:locale].has_an_error?
          assert field[:company].has_an_error?
        end

      #
      # description is present
      #
      document.description = 'description'

      CheckFieldPresenceValidation.of(document)
        .then do |field|
          refute field[:title].has_an_error?
          refute field[:description].has_an_error?

          assert field[:locale].has_an_error?
          assert field[:company].has_an_error?
        end

      #
      # locale is present
      #
      document.locale = 'locale'

      CheckFieldPresenceValidation.of(document)
        .then do |field|
          refute field[:title].has_an_error?
          refute field[:description].has_an_error?
          refute field[:locale].has_an_error?

          assert field[:company].has_an_error?
        end

      #
      # locale is present
      #
      document.company = 'company'

      CheckFieldPresenceValidation.of(document)
        .then do |field|
          refute %i[title description locale company]
            .map(&field)
            .any?(&:has_an_error?)
        end
    end
  end
end
