class Image
  include ActiveModel::Serialization

  ATTRS = %i(name source command categories links ports expose environment
    volumes volumes_from deployment)

  attr_accessor *ATTRS

  def initialize(attrs={})
    self.name = attrs['name']
    self.source = attrs['source']
    self.command = attrs['command']
    self.categories = attrs['categories'] || []
    self.links = attrs['links'] || []
    self.ports = attrs['ports'] || []
    self.expose = attrs['expose'] || []
    self.environment = attrs['environment'] || []
    self.volumes = attrs['volumes'] || []
    self.volumes_from = attrs['volumes_from'] || []
    self.deployment = attrs['deployment'] || {}
  end

  def override(other_image)
    return unless other_image

    self.command = other_image.command if other_image.command

    self.deployment.merge!(other_image.deployment)

    self.links += other_image.links if other_image.links.any?
    self.expose += other_image.expose if other_image.expose.any?
    self.volumes_from += other_image.volumes_from if other_image.volumes_from.any?

    merge_arrays(self.environment, other_image.environment, 'variable')
    merge_arrays(self.ports, other_image.ports, 'container_port')
    merge_arrays(self.volumes, other_image.volumes, 'container_path')
  end

  def eql?(other)
    to_hash.eql?(other.try(:to_hash))
  end

  alias_method :==, :eql?

  def to_hash
    ATTRS.each_with_object({}) do |attr, memo|
      memo[attr] = self.send(attr)
    end
  end

  private

  def merge_arrays(base_array, override_array, match_key)
    override_array.each do |override_item|

      index = base_array.find_index do |base_item|
        base_item[match_key] == override_item[match_key]
      end

      if index
        base_array[index] = override_item
      else
        base_array << override_item
      end
    end
  end
end
