require 'spec_helper'

describe ImageConverter do

  subject do
    Class.new do
      include ImageConverter
    end.new
  end

  describe '#image_to_service' do

    context 'when the image is sparsely populated' do

      it 'converts the image properly' do
        image = {
          'name' => 'a',
          'source' => 'b'
        }

        expected = {
          'name' => 'a',
          'source' => 'b'
        }

        expect(subject.image_to_service(image)).to eq expected
      end
    end

    context 'when the image is fully populated' do

      it 'converts the image properly' do
        image = {
          'name' => 'a',
          'source' => 'b',
          'command' => 'c',
          'environment' => [
            { 'variable' => 'd', 'value' => 'e' },
            { 'variable' => 'f', 'value' => 'g' }
          ],
          'links' => [
            { 'service' => 'h', 'alias' => 'i' },
            { 'service' => 'j', 'alias' => 'k' }
          ],
          'expose' => ['l', 'm'],
          'ports' => [
            { 'container_port' => 'n', 'host_port' => 'o', 'proto' => 'p' },
            { 'container_port' => 'q', 'host_port' => 'r', 'proto' => 's' },
          ],
          'volumes' => [
            { 'container_path' => 't', 'host_path' => 'u' },
            { 'container_path' => 'v', 'host_path' => 'w' }
          ]
        }

        expected = {
          'name' => 'a',
          'source' => 'b',
          'command' => 'c',
          'environment' => [
            { 'variable' => 'd', 'value' => 'e' },
            { 'variable' => 'f', 'value' => 'g' }
          ],
          'links' => [
            { 'name' => 'h', 'alias' => 'i' },
            { 'name' => 'j', 'alias' => 'k' }
          ],
          'expose' => ['l', 'm'],
          'ports' => [
            { 'containerPort' => 'n', 'hostPort' => 'o', 'protocol' => 'P' },
            { 'containerPort' => 'q', 'hostPort' => 'r', 'protocol' => 'S' },
          ],
          'volumes' => [
            { 'containerPath' => 't', 'hostPath' => 'u' },
            { 'containerPath' => 'v', 'hostPath' => 'w' }
          ]
        }

        expect(subject.image_to_service(image)).to eq expected
      end
    end
  end
end
