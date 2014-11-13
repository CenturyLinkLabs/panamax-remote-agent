require 'spec_helper'

describe OrchestrationAdapter::Client do

  let(:connection) { double(:connection) }

  subject { OrchestrationAdapter::Client.new(connection: connection) }

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

    let(:service_id) { 's 1' }
    let(:response) { double(:response, status: nil, body: 'FOO') }

    before do
      connection.stub(:get).and_return(response)
    end

    it 'GETs /services/:id' do
      expect(connection).to receive(:get).with('v1/services/s%201')
      subject.get_service(service_id)
    end

    context 'when response is good' do

      let(:response) { double(:response, status: 200, body: 'FOO') }

      it 'returns the response body' do
        expect(subject.get_service(service_id)).to eq response.body
      end
    end

    context 'when response is a not found error' do

      before do
        connection.stub(:get).and_raise(OrchestrationAdapter::NotFound)
      end

      it 'returns a not found message' do
        expect(subject.get_service(service_id)).to eq(
          'id' => service_id, 'actualState' => 'not found')
      end
    end

    context 'when response is some other error' do

      before do
        connection.stub(:get).and_raise(OrchestrationAdapter::Conflict)
      end

      it 'returns a not found message' do
        expect(subject.get_service(service_id)).to eq(
          'id' => service_id, 'actualState' => 'error')
      end
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

    context 'when the response is good' do
      it 'returns true' do
        expect(subject.delete_service(service_id)).to eq true
      end
    end

    context 'when the response is an error' do

      before do
        connection.stub(:delete).and_raise(OrchestrationAdapter::NotFound)
      end

      it 'returns true' do
        expect(subject.delete_service(service_id)).to eq true
      end
    end
  end
end
