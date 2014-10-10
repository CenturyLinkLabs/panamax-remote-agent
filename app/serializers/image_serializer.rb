class ImageSerializer < ActiveModel::Serializer
  self.root = false

  attributes :name, :source, :categories, :command, :environment, :links,
    :expose, :ports, :volumes, :volumesFrom, :deployment

  def ports
    object.ports.map do |port|
      {}.tap do |h|
        h[:containerPort] = port['container_port']
        h[:hostPort] = port['host_port'] if port['host_port']
        h[:protocol] = port['proto'].upcase if port['proto']
      end
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

end
