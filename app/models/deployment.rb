class Deployment < ActiveRecord::Base

  before_destroy :undeploy_services

  serialize :service_ids, Array

  class << self

    def deploy(template, override=nil)
      template.override(override) if override

      services = services_from_template(template)
      deployed_services = adapter_client.create_services(services)

      create(name: template.name, template: template.to_json, service_ids: service_ids(deployed_services))
    end

    private

    def services_from_template(template)
      template.images.map { |image| ImageSerializer.new(image) }
    end

    def service_ids(services)
      services.map { |service| service['id'] }
    end

    def adapter_client
      OrchestrationAdapter::Client.new(logger: logger)
    end
  end

  def stop
    update_service_states(:stopped)
  end

  def start
    update_service_states(:started)
  end

  def status
    {
      services: service_ids.map do |service_id|
        adapter_client.get_service(service_id)
      end
    }
  end

  def redeployable?
    template?
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
