module OrchestrationAdapter::Client::Services

  API_VERSION = 'v1'

  def create_services(services)
    response = connection.post services_path, services.to_json
    response.body
  end

  def get_service(service_id)
    response = connection.get services_path(service_id)
    response.body
  rescue OrchestrationAdapter::NotFound => ex
    { 'id' => service_id, 'actualState' => 'not found' }
  rescue OrchestrationAdapter::Error => ex
    { 'id' => service_id, 'actualState' => 'error' }
  end

  def update_service(service_id, desired_state)
    connection.put services_path(service_id), desiredState: desired_state
    true
  end

  def delete_service(service_id)
    connection.delete services_path(service_id)
    true
  rescue OrchestrationAdapter::Error
    true
  end

  protected

  def services_path(id=nil)
    parts = [API_VERSION, 'services']
    parts << URI.escape(id, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]")) if id
    parts.join('/')
  end
end
