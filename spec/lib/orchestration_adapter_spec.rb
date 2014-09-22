require 'spec_helper'

describe OrchestrationAdapter do

  describe '.new' do

    it 'returns an instance of OrchestrationAdapater::Client' do
      expect(described_class.new).to be_a OrchestrationAdapter::Client
    end

    it 'passes options to the client' do
      dummy_connection = double(:client)
      client = described_class.new(connection: dummy_connection)

      expect(client.connection).to eq dummy_connection
    end
  end
end
