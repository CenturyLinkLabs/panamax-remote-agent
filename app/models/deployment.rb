class Deployment < ActiveRecord::Base

  before_destroy :undeploy_services

  serialize :service_ids, Array

  def self.deploy(template)
    images = YAML.safe_load(template)['images']

    services = images.map do |image|
      {
        name: image['name'],
        source: image['source'],
        command: image['command']
      }
    end

    service_ids = adapter_client.create_services(services)
    create(service_ids: service_ids)
  end

  def self.adapter_client
    PanamaxAgent.adapter_client
  end
  private_class_method :adapter_client

  def stop
    update_service_states(:stopped)
  end

  def start
    update_service_states(:started)
  end

  def status
    service_status = service_ids.map do |service_id|
      adapter_client.get_service(service_id)
    end

    overall_status = 'error' if service_status.any? { |s| s['status'] == 'error' }

    unless overall_status
      overall_status = service_status.all? { |s| s['status'] == 'started' } ? 'started' : 'stopped'
    end

    {
      overall: overall_status,
      services: service_status
    }
  end

  private

  def update_service_states(desired_state)
    service_ids.each do |service_id|
      adapter_client.update_service(service_id, desired_state)
    end
  end

  def undeploy_services
    service_ids.each do |service_id|
      adapter_client.delete_service(service_id)
    end
  end

  def adapter_client
    self.class.send(:adapter_client)
  end
end
