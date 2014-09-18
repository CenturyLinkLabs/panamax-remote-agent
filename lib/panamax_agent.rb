require 'panamax_agent/configuration'
require 'panamax_agent/orchestration_adapter/client'

module PanamaxAgent
  extend Configuration

  def self.adapter_client(options={})
    PanamaxAgent::OrchestrationAdapter::Client.new(options)
  end

  def self.configure
    yield self
    true
  end
end
