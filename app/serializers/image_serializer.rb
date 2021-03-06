class ImageSerializer < ActiveModel::Serializer
  self.root = false

  attributes :name, :source, :categories, :command, :environment, :links,
    :expose, :ports, :volumes, :volumesFrom, :deployment

  def links
    object.links.map do |link|
      {}.tap do |h|
        h[:name] = link['service']
        h[:alias] = link['alias']
      end
    end
  end

  def ports
    object.ports.map do |port|
      {}.tap do |h|
        h[:containerPort] = port['container_port'].to_i
        h[:hostPort] = port['host_port'].to_i if port['host_port']
        h[:protocol] = port['proto'].upcase if port['proto']
      end
    end
  end

  def expose
    object.expose.map do |exposed_port|
      exposed_port.to_i
    end
  end

  def volumes
    object.volumes.map do |volume|
      {}.tap do |h|
        h[:containerPath] = volume['container_path']
        h[:hostPath] = volume['host_path'] if volume['host_path']
      end
    end
  end

  def volumesFrom
    object.volumes_from
  end

  def deployment
    object.deployment.each_with_object({}) do |(key, value), h|
      h[key.to_sym] = (key == 'count') ? value.to_i : value
    end
  end
end
