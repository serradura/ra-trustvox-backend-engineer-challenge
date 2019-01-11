module ExceptionHandlers
  ParameterMissing = -> exception do
    render status: :bad_request, json: { error: [exception.message] }
  end
end
