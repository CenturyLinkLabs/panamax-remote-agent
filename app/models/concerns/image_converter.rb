module ImageConverter
  extend ActiveSupport::Concern

  def image_to_service(image)
    {}.tap do |h|
      h['name'] = image['name']
      h['source'] = image['source']
      h['command'] = image['command'] if image['command']
      h['environment'] = image['environment'] if image['environment']
      h['links'] = links(image['links']) if image['links']
      h['expose'] = image['expose'] if image['expose']
      h['ports'] = ports(image['ports']) if image['ports']
      h['volumes'] = volumes(image['volumes']) if image['volumes']
    end
  end

  private

  def links(image_links)
    image_links.map do |image_link|
      {}.tap do |h|
        h['name'] = image_link['service']
        h['alias'] = image_link['alias'] if image_link['alias']
      end
    end
  end

  def ports(image_ports)
    image_ports.map do |image_port|
      {}.tap do |h|
        h['containerPort'] = image_port['container_port']
        h['hostPort'] = image_port['host_port'] if image_port['host_port']
        h['protocol'] = image_port['proto'].upcase if image_port['proto']
      end
    end
  end

  def volumes(image_volumes)
    image_volumes.map do |image_volume|
      {}.tap do |h|
        h['containerPath'] = image_volume['container_path']
        h['hostPath'] = image_volume['host_path'] if image_volume['host_path']
      end
    end
  end
end
