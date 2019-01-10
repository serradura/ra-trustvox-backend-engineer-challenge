class ApplicationController < ActionController::API
  rescue_from ActionController::RoutingError do
    render status: :ok, json: {}
  end

  rescue_from(ActionController::ParameterMissing) do |exception|
    render status: :bad_request, json: { error: exception.message }
  end
end
