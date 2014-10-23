require 'spec_helper'

describe 'Metadata Endpoint' do
  describe 'GET /metadata' do
    let(:response) { get '/metadata', format: :json }
    let(:adapter_metadata) { { 'version' => '0.2.0', 'type' => 'Test' } }
    let(:client) { double(get_metadata: adapter_metadata) }
    subject(:hash) { JSON.parse(response.body) }
    before { OrchestrationAdapter::Client.stub(new: client) }

    it 'has a 200 response code' do
      expect(response.status).to eq(200)
    end

    it 'has a JSON Content-Type' do
      expect(response.headers['Content-Type']).to start_with('application/json')
    end

    its(:keys) { should eq([ 'agent', 'adapter' ]) }

    describe 'the agent metadata JSON' do
      before { stub_const('PanamaxRemoteAgent::VERSION', '10') }
      subject { hash['agent'] }

      its(:keys) { should eq([ 'version' ]) }
      its(['version']) { should eq('10') }
    end

    describe 'the adapter metadata JSON' do
      subject { hash['adapter'] }

      its(:keys) { should eq([ 'version', 'type' ]) }
      its(['version']) { should eq('0.2.0') }
      its(['type']) { should eq('Test') }
    end
  end
end
