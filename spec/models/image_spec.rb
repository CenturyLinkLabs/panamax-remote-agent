require 'spec_helper'

describe Image do

  let(:attrs) do
    {
      'name' => 'foo',
      'source' => 'centurylink/bar',
      'command' => '/bin/bash',
      'categories' => [ 'cat1' ],
      'links' => [
        { 'name' => 'mysql', 'alias' => 'db' }
      ],
      'ports' => [
        { 'container_port' => 1111, 'host_port' => 2222 }
      ],
      'expose' => [3333],
      'environment' => [
        { 'variable' => 'VAR1', 'value' => 'VAL1' }
      ],
      'volumes' => [
        { 'container_path' => 'a/b', 'host_path' => 'c/d' }
      ],
      'volumes_from' => [
        { 'service' => 'volsvc' }
      ],
      'deployment' => { 'count' => 1 }
    }
  end

  describe '#initialize' do

    context 'when no attrs are specified' do

      it 'initializes an empty Image' do
        image = described_class.new

        expect(image.name).to be_nil
        expect(image.source).to be_nil
        expect(image.command).to be_nil
        expect(image.categories).to eq []
        expect(image.links).to eq []
        expect(image.ports).to eq []
        expect(image.expose).to eq []
        expect(image.environment).to eq []
        expect(image.volumes).to eq []
        expect(image.volumes_from).to eq []
        expect(image.deployment).to eq({})
      end
    end

    context 'when attrs are specified' do
      it 'initiazes the Image with the provided attrs' do
        image = described_class.new(attrs)

        expect(image.name).to eq attrs['name']
        expect(image.source).to eq attrs['source']
        expect(image.command).to eq attrs['command']
        expect(image.links).to eq attrs['links']
        expect(image.ports).to eq attrs['ports']
        expect(image.expose).to eq attrs['expose']
        expect(image.environment).to eq attrs['environment']
        expect(image.volumes).to eq attrs['volumes']
        expect(image.volumes_from).to eq attrs['volumes_from']
        expect(image.deployment).to eq attrs['deployment']
      end
    end
  end

  describe '#override' do

    subject { described_class.new(deep_copy(attrs)) }

    let(:expected_image) { described_class.new(deep_copy(attrs)) }

    context 'when override image is nil' do
      it 'leaves the original image untouched' do
        subject.override(nil)
        expect(subject).to eq expected_image
      end
    end

    context 'when the override image is empty' do
      it 'leaves the original image untouched' do
        subject.override(described_class.new)
        expect(subject).to eq expected_image
      end
    end

    context 'when the override image has a deployment' do

      let(:deployment) { { 'count' => 3 } }
      let(:override_image) { described_class.new('deployment' => deployment) }

      it 'sets the deployment' do
        expected_image.deployment = deployment

        subject.override(override_image)
        expect(subject).to eq expected_image
      end
    end

    context 'when the override image has a command' do

      let(:command) { 'ABC123' }
      let(:override_image) { described_class.new('command' => command) }

      it 'overrides the command' do
        expected_image.command = command

        subject.override(override_image)
        expect(subject).to eq expected_image
      end
    end

    context 'when the override image has links' do
      let(:link) { { 'name' => 'X', 'alias' => 'Y' } }
      let(:override_image) { described_class.new('links' => [link]) }

      it 'adds the link' do
        expected_image.links << link

        subject.override(override_image)
        expect(subject).to eq expected_image
      end
    end

    context 'when the override image has exposed ports' do
      let(:exposed_port) { 9999 }
      let(:override_image) { described_class.new('expose' => [exposed_port]) }

      it 'adds the link' do
        expected_image.expose << exposed_port

        subject.override(override_image)
        expect(subject).to eq expected_image
      end
    end

    context 'when the override image has volumes_from' do
      let(:volume_from) { { 'service' => 'ABC' } }
      let(:override_image) { described_class.new('volumes_from' => [volume_from]) }

      it 'adds the volumes_from' do
        expected_image.volumes_from << volume_from

        subject.override(override_image)
        expect(subject).to eq expected_image
      end
    end

    context 'when the override image has an environment' do

      context 'when the override image overrides an existing env variable' do

        let(:env_var) { { 'variable' => 'VAR1', 'value' => 'VAL2' } }
        let(:override_image) { described_class.new('environment' => [env_var]) }

        it 'overrides the existing env variable' do
          expected_image.environment[0] = env_var

          subject.override(override_image)
          expect(subject).to eq expected_image
        end

      end

      context 'when the override images provides a new env variable' do

        let(:env_var) { { 'variable' => 'VAR2', 'value' => 'VAL2' } }
        let(:override_image) { described_class.new('environment' => [env_var]) }

        it 'adds a new env variable' do
          expected_image.environment << env_var

          subject.override(override_image)
          expect(subject).to eq expected_image
        end
      end
    end

    context 'when the override image has ports' do

      context 'when the override image overrides an existing port' do

        let(:port) { { 'container_port' => 1111, 'host_port' => 9999 } }
        let(:override_image) { described_class.new('ports' => [port]) }

        it 'overrides the existing port' do
          expected_image.ports[0] = port

          subject.override(override_image)
          expect(subject).to eq expected_image
        end

      end

      context 'when the override images provides a new port' do

        let(:port) { { 'container_port' => 2222, 'host_port' => 3333 } }
        let(:override_image) { described_class.new('ports' => [port]) }

        it 'adds a new port' do
          expected_image.ports << port

          subject.override(override_image)
          expect(subject).to eq expected_image
        end
      end
    end

    context 'when the override image has volumes' do

      context 'when the override image overrides an existing volume' do

        let(:volume) { { 'container_path' => 'a/b', 'host_path' => 'x/y' } }
        let(:override_image) { described_class.new('volumes' => [volume]) }

        it 'overrides the existing volume' do
          expected_image.volumes[0] = volume

          subject.override(override_image)
          expect(subject).to eq expected_image
        end

      end

      context 'when the override images provides a new volume' do

        let(:volume) { { 'container_path' => 'c/d', 'host_path' => 'x/y' } }
        let(:override_image) { described_class.new('volumes' => [volume]) }

        it 'adds a new volume' do
          expected_image.volumes << volume

          subject.override(override_image)
          expect(subject).to eq expected_image
        end
      end
    end
  end

  describe 'comparison' do

    let(:thing_1) { described_class.new(attrs) }
    let(:thing_2) { described_class.new(attrs) }
    let(:not_a_thing) { described_class.new }

    describe '#eql?' do
      context 'when objects are not of the same type' do
        it 'returns false' do
          expect(thing_1.eql?(nil)).to be_false
        end
      end

      context 'when objects have value equality' do
        it 'returns true' do
          expect(thing_1.eql?(thing_2)).to be_true
        end
      end

      context 'when objects have no value equality' do
        it 'returns false' do
          expect(thing_1.eql?(not_a_thing)).to be_false
        end
      end
    end

    describe '#==' do
      context 'when objects are not of the same type' do
        it 'returns false' do
          expect(thing_1 == nil).to be_false
        end
      end

      context 'when objects have value equality' do
        it 'returns true' do
          expect(thing_1 == thing_2).to be_true
        end
      end

      context 'when objects have no value equality' do
        it 'returns false' do
          expect(thing_1 == not_a_thing).to be_false
        end
      end
    end

    describe '#equal?' do
      context 'when objects have identity equality' do
        it 'returns true' do
          expect(thing_1.equal?(thing_1)).to be_true
        end
      end

      context 'when objects have no identity equality' do
        it 'returns false' do
          expect(thing_1.equal?(thing_2)).to be_false
        end
      end
    end
  end
end
