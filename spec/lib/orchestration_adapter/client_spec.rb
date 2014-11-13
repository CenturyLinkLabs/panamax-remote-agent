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

end
