class MetadataController < ApplicationController
  respond_to :json

  def show
    respond_with(
      {
        agent: { version: PanamaxRemoteAgent::VERSION },
        adapter: client.get_metadata
      }
    )
  end

protected

  def client
    @client ||= OrchestrationAdapter::Client.new
  end
end
