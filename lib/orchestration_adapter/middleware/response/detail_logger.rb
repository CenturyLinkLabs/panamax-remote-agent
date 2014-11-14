require 'forwardable'

module OrchestrationAdapter::Middleware::Response

  class DetailLogger < Faraday::Response::Middleware
    extend Forwardable

    def initialize(app, logger)
      super(app)
      @logger = logger
    end

    def_delegators :@logger, :debug, :info

    def call(env)
      info "REQUEST: #{env[:method].upcase} #{env[:url].to_s}"
      debug { format_headers(env[:request_headers]) }

      if env[:body] && !env[:body].empty?
        debug { "  #{env[:body]}" }
      end

      super
    end

    def on_complete(env)
      info "RESPONSE: #{env[:status].to_s}"
      debug { format_headers(env[:response_headers]) }

      if env[:response].body && !env[:response].body.empty?
        debug { "  #{env[:response].body}" }
      end
    end

    private

    def format_headers(headers)
      headers.map { |k, v| "  #{k}: #{v.inspect}" }.join("\n")
    end

    Faraday.register_middleware :response, detail_logger: -> { DetailLogger }
  end
end
