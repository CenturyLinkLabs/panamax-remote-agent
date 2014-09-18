require 'panamax_agent/client'
require 'panamax_agent/orchestration_adapter/client/services'

module PanamaxAgent
  module OrchestrationAdapter
    class Client < PanamaxAgent::Client

      include PanamaxAgent::OrchestrationAdapter::Connection
      include PanamaxAgent::OrchestrationAdapter::Client::Services

    end
  end
end
