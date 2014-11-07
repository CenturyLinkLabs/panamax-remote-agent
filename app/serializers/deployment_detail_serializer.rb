class DeploymentDetailSerializer < ActiveModel::Serializer
  self.root = false

  attributes :id, :name, :status
end
