module PanamaxAgent
  module OrchestrationAdapter
    class Client < PanamaxAgent::Client
      module Services

        SERVICES_RESOURCE = 'services'

        def list_services
          get(services_path)
        end

        def create_services(services)
          payload = { services: services }
          post(services_path, payload)
        end

        def get_service(service_id)
          get(services_path(service_id))
        end

        def update_service(service_id, desired_state)
          put(services_path(service_id), desired_state: desired_state)
        end

        def delete_service(service_id)
          delete(services_path(service_id))
        end

        private

        def services_path(*parts)
          resource_path(SERVICES_RESOURCE, *parts)
        end

      end
    end
  end
end
