require 'orchestration_adapter/middleware/response/detail_logger'

module OrchestrationAdapter
  class Client
    include Services
    include Metadata

    attr_reader :connection

    def initialize(options={})
      adapter_url = options[:adapter_url] ||
        (ENV['ADAPTER_PORT'] ? ENV['ADAPTER_PORT'].gsub('tcp', 'http') : nil)

      @logger = options[:logger]
      @connection = options[:connection] || default_connection(adapter_url)
    end

    private

    def default_connection(url)
      Faraday.new(url: url) do |faraday|
        faraday.request :json
        faraday.response :json
        faraday.response :detail_logger, @logger
        faraday.adapter Faraday.default_adapter
      end
    end
  end
end
