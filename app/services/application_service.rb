# frozen_string_literal: true

class ApplicationService
  RESULTS = [
    FAILURE = :failure,
    SUCCESS = :success
  ].freeze

  def call
    raise NotImplementedError
  end
end
