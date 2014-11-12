require 'spec_helper'

describe DeploymentDetailSerializer do
  let(:deployment_model) { Deployment.new }

  it 'exposes the attributes to be jsonified' do
    serialized = described_class.new(deployment_model).as_json
    expected_keys = [
        :id,
        :name,
        :status
    ]
    expect(serialized.keys).to match_array expected_keys
  end
end
