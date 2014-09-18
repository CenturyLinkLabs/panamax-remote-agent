class DeploymentDetailSerializer < ActiveModel::Serializer
  self.root = false

  attributes :id, :status
end
