require 'spec_helper'

describe OrchestrationAdapter::Client do
  let(:connection) { double(:connection) }
  subject(:client) { OrchestrationAdapter::Client.new(connection: connection) }

  describe '#get_metadata' do
    let(:adapter_metadata) do
      { 'version' => '1' }
    end
    subject(:metadata) { client.get_metadata }
    before do
      connection.stub(:get).and_return(double(body: adapter_metadata))
      metadata
    end

    it 'requests the correct endpoint of the adapter' do
      expect(connection).to have_received(:get).with('/v1/metadata')
    end

    it { should eq({ 'version' => '1' }) }
  end
end
