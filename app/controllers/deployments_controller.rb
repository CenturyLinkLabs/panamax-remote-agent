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
    template = Template.new(params[:template])
    override = Template.new(params[:override])

    respond_with Deployment.deploy(template, override)
  end

  def destroy
    respond_with Deployment.find(params[:id]).destroy
  end
end
