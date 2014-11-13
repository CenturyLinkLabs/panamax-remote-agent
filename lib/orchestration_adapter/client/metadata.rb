module OrchestrationAdapter::Client::Metadata
  def get_metadata
    connection.get('/v1/metadata').body
  end
end
