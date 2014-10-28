module OrchestrationAdapter
  class Client

    attr_reader :connection

    def initialize(options={})
      adapter_url = options[:adapter_url] ||
        (ENV['ADAPTER_PORT'] ? ENV['ADAPTER_PORT'].gsub('tcp', 'http') : nil)

      @connection = options[:connection] || default_connection(adapter_url)
    end

    def create_services(services)
      response = connection.post services_path, services.to_json
      response.body
    end

    def get_service(service_id)
      response = connection.get services_path(service_id)
      response.body
    end

    def update_service(service_id, desired_state)
      connection.put services_path(service_id), desiredState: desired_state
      true
    end

    def delete_service(service_id)
      connection.delete services_path(service_id)
      true
    end

    private

    def default_connection(url)
      Faraday.new(url: url) do |faraday|
        faraday.request :json
        faraday.response :json
        faraday.adapter Faraday.default_adapter
      end
    end

    def services_path(*parts)
      parts.unshift('services').join('/')
    end
  end
end
