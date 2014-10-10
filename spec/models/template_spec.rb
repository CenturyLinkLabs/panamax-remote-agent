require 'spec_helper'

describe Template do

  let(:attrs) do
    {
      'name' => 'foo',
      'description' => 'bar',
      'images' => [ { 'name' => 'image1' } ]
    }
  end

  describe '#initialize' do

    context 'when no attributes are specified' do
      it 'initializes an empty Template' do
        template = described_class.new
        expect(template.name).to be_nil
        expect(template.description).to be_nil
        expect(template.images).to eq []
      end
    end

    context 'when attributes are specified' do
      it 'initializes the Template with the provided attrs' do
        template = described_class.new(attrs)

        expect(template.name).to eq attrs['name']
        expect(template.description).to eq attrs['description']
        expect(template.images.count).to eq 1
        expect(template.images.first).to be_kind_of Image
      end
    end
  end

  describe '#override' do

    subject { described_class.new(deep_copy(attrs)) }

    context 'when the override template contains a matching image' do

      let(:override_template) { described_class.new(deep_copy(attrs)) }

      it 'calls override on the image' do
        base_image = subject.images.first
        override_image = override_template.images.first

        expect(base_image).to receive(:override).with(override_image)

        subject.override(override_template)
      end
    end

    context 'when the override template does not contain a matching image' do

      let(:override_template) do
        described_class.new('images' => [ { 'name' => 'image2' } ])
      end

      it 'does NOT call override on any images' do
        base_image = subject.images.first
        expect(base_image).to_not receive(:override)

        subject.override(override_template)
      end
    end
  end
end
