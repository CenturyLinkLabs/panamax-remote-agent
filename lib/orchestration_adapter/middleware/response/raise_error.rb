require 'faraday'
require 'orchestration_adapter/error'

module OrchestrationAdapter::Middleware::Response

  class RaiseError < Faraday::Response::Middleware

    def on_complete(env)
      status = env[:status].to_i
      return unless (400..600).include?(status)

      message = extract_message(env[:body])

      class_name =
        OrchestrationAdapter::Error::HTTP_CODE_MAP.fetch(status, 'Error')

      fail OrchestrationAdapter.const_get(class_name).new(message)
    end

    private

    def extract_message(body)
      json = JSON.parse(body)
      json['message'] || json['error'] || body
    rescue StandardError
      body.to_s
    end

    Faraday.register_middleware :response, raise_error: -> { RaiseError }
  end
end
