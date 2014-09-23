class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  if Rails.env.production?
    http_basic_authenticate_with name: PanamaxRemoteAgent::USERNAME,
      password: PanamaxRemoteAgent::PASSWORD
  end

end
