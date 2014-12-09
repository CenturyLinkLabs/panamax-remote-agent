class DeploymentSerializer < ActiveModel::Serializer
  self.root = false

  attributes :id, :name, :service_ids, :redeployable

  def redeployable
    object.redeployable?
  end
end
