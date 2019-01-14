# frozen_string_literal: true

class ApplicationService
  RESULTS = [
    FAILURE = :failure,
    SUCCESS = :created
  ].freeze

  def call
    raise NotImplementedError
  end
end
