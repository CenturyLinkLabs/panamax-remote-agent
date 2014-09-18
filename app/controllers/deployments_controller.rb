class DeploymentsController < ApplicationController

  respond_to :json

  def index
    respond_with Deployment.all
  end

  def show
    respond_with Deployment.find(params[:id]),
      serializer: DeploymentDetailSerializer
  end

  def create
    respond_with Deployment.deploy(params[:template])
  end

  def destroy
    respond_with Deployment.find(params[:id]).destroy
  end
end
