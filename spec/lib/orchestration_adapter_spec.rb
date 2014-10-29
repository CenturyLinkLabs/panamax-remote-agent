require 'spec_helper'

describe OrchestrationAdapter::Client do

  let(:connection) { double(:connection) }

  subject { OrchestrationAdapter::Client.new(connection: connection) }

  describe '#initialize' do

    context 'when the connection is injected' do

      it 'uses the injected connection' do
        expect(subject.connection).to eq connection
      end
    end

    context 'when the adapater_url is injected' do

      let(:url) { 'http://www.foo.com/' }

      subject { OrchestrationAdapter::Client.new(adapter_url: url) }

      it 'creates a connection with that url' do
        expect(subject.connection.url_prefix.to_s).to eq url
      end
    end

    context 'when the ADAPTER_PORT environment variable is set' do

      let(:url) { 'tcp://www.bar.com:3000' }

      subject { OrchestrationAdapter::Client.new }

      before do
        ENV.stub(:[])
        ENV.stub(:[]).with('ADAPTER_PORT').and_return(url)
      end

      it 'creates a connection with the ADAPTER_PORT environment variable' do
        expect(subject.connection.url_prefix.to_s).to eq 'http://www.bar.com:3000/'
      end
    end
  end

  describe '#create_services' do

    let(:services) { [ :service1, :service2 ] }
    let(:response) { double(:response, body: 'FOO') }

    before do
      connection.stub(:post).and_return(response)
    end

    it 'POSTs to /services' do
      expect(connection).to receive(:post).with('v1/services', services.to_json)
      subject.create_services(services)
    end

    it 'returns the response body' do
      expect(subject.create_services(services)).to eq response.body
    end
  end

  describe '#get_service' do

    let(:service_id) { 's1' }
    let(:response) { double(:response, body: 'FOO') }

    before do
      connection.stub(:get).and_return(response)
    end

    it 'GETs /services/:id' do
      expect(connection).to receive(:get).with("v1/services/#{service_id}")
      subject.get_service(service_id)
    end

    it 'returns the response body' do
      expect(subject.get_service(service_id)).to eq response.body
    end
  end

  describe '#update_service' do

    let(:service_id) { 's1' }
    let(:desired_state) { 'running' }

    before do
      connection.stub(:put)
    end

    it 'PUTs /services/:id' do
      expect(connection).to(
        receive(:put).with("v1/services/#{service_id}", desiredState: desired_state))
      subject.update_service(service_id, desired_state)
    end

    it 'returns true' do
      expect(subject.update_service(service_id, desired_state)).to eq true
    end
  end

  describe '#delete_service' do

    let(:service_id) { 's1' }

    before do
      connection.stub(:delete)
    end

    it 'DELETEs /services/:id' do
      expect(connection).to receive(:delete).with("v1/services/#{service_id}")
      subject.delete_service(service_id)
    end

    it 'returns true' do
      expect(subject.delete_service(service_id)).to eq true
    end
  end
end
