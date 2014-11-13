class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  if Rails.env.production?
    http_basic_authenticate_with name: PanamaxRemoteAgent::USERNAME,
      password: PanamaxRemoteAgent::PASSWORD
  end

  rescue_from StandardError, with: :handle_exception

  rescue_from Faraday::Error::ConnectionFailed do |ex|
    handle_exception(ex, :adapter_connection_error)
  end

  def handle_exception(ex, message=nil, &block)
    log_message = "\n#{ex.class} (#{ex.message}):\n"
    log_message << "  " << ex.backtrace.join("\n  ") << "\n\n"
    logger.error(log_message)

    message = message.nil? ? ex.message : t(message, default: message.to_s)

    block.call(message) if block_given?

    unless performed?
      render json: { message: message }, status: :internal_server_error
    end
  end
end
