require 'orchestration_adapter/client'

module OrchestrationAdapter
  def self.new(options={})
    OrchestrationAdapter::Client.new(options)
  end
end
