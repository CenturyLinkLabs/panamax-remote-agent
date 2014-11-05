require 'spec_helper'

describe ImageSerializer do

  let(:image) do
    Image.new(
      'links' => [
        { 'service' => 'a', 'alias' => 'b' }
      ],
      'ports' => [
        { 'container_port' => '1111', 'host_port' => '2222', 'proto' => 'UDP' }
      ],
      'expose' => ['3333'],
      'volumes' => [
        { 'container_path' => 'a/b', 'host_path' => 'c/d' }
      ],
      'volumes_from' => [
        { 'service' => 'svc1' }
      ],
      'deployment' => { 'count' => '2' }
    )
  end

  subject { described_class.new(image) }

  describe '#as_json' do

    it 'exposes the attributes to be jsonified' do
      serialized = subject.as_json

      expected_keys = %i(
        name
        source
        categories
        command
        environment
        links
        expose
        ports
        volumes
        volumesFrom
        deployment
      )

      expect(serialized.keys).to match_array expected_keys
    end

    it 're-maps the keys for any links' do
      serialized = subject.as_json

      expect(serialized[:links].count).to eq 1
      link = serialized[:links].first

      expect(link[:name]).to eq image.links.first['service']
      expect(link[:alias]).to eq image.links.first['alias']
    end

    it 're-maps the keys for any ports' do
      serialized = subject.as_json

      expect(serialized[:ports].count).to eq 1
      port = serialized[:ports].first

      expect(port[:containerPort]).to eq image.ports.first['container_port'].to_i
      expect(port[:hostPort]).to eq image.ports.first['host_port'].to_i
      expect(port[:protocol]).to eq image.ports.first['proto']
    end

    it 'translates exposed ports to integers' do
      serialized = subject.as_json

      expect(serialized[:expose].count).to eq 1
      exposed_port = serialized[:expose].first

      expect(exposed_port).to eq image.expose.first.to_i
    end

    it 're-maps the keys for any volumes' do
      serialized = subject.as_json

      expect(serialized[:volumes].count).to eq 1
      volume = serialized[:volumes].first

      expect(volume[:containerPath]).to eq image.volumes.first['container_path']
      expect(volume[:hostPath]).to eq image.volumes.first['host_path']
    end

    it 're-maps the volumes_from key' do
      serialized = subject.as_json
      expect(serialized[:volumesFrom]).to eq image.volumes_from
    end

    it 'converts deployment count to an integer' do
      serialized = subject.as_json
      expect(serialized[:deployment]).to eq count: 2
    end
  end
end
