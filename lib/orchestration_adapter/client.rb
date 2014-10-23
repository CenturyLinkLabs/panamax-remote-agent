module OrchestrationAdapter
  class Client
    include Services
    include Metadata

    attr_reader :connection

    def initialize(options={})
      adapter_url = options[:adapter_url] ||
        (ENV['ADAPTER_PORT'] ? ENV['ADAPTER_PORT'].gsub('tcp', 'http') : nil)

      @connection = options[:connection] || default_connection(adapter_url)
    end

    private

    def default_connection(url)
      Faraday.new(url: url) do |faraday|
        faraday.request :json
        faraday.response :json
        faraday.adapter Faraday.default_adapter
      end
    end
  end
end
