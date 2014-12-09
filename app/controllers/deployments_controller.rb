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

  def redeploy
    deployment = Deployment.find(params[:id])
    if deployment.redeployable?
      deployment.destroy
      template_attrs = JSON.parse(deployment.template)
      template = Template.new(template_attrs)
      respond_with Deployment.deploy(template)
    else
      raise t(:not_redeployable_error, deployment: deployment.name)
    end
  end
end
