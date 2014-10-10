class Template

  attr_accessor :name, :description, :images

  def initialize(attrs={})
    self.name = attrs['name']
    self.description = attrs['description']

    self.images = Array(attrs['images']).map do |image_attrs|
      Image.new(image_attrs)
    end
  end

  def override(other_template)
    other_template.images.each do |other_image|
      image = self.images.find { |image| image.name == other_image.name }
      image.override(other_image) if image
    end
  end
end
