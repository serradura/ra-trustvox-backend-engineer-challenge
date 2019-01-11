# frozen_string_literal: true

require_relative './routes/json_constraint'

Rails.application.routes.draw do
  namespace(complaints = :complaints, constraints: Routes::JSONConstraint) do
    namespace :v1 do
      get :index, to: 'index#call'
      post :create, to: 'create#call'
    end

    get '/', to: 'v1/index#call'
    post '/', to: 'v1/create#call'
  end

  root to: 'errors/v1/not_found#call', via: :all

  match '*unmatched', to: 'errors/v1/not_found#call', via: :all
end
