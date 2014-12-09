class DeploymentDetailSerializer < ActiveModel::Serializer
  self.root = false

  attributes :id, :status, :name, :redeployable

  def redeployable
    object.redeployable?
  end

end
