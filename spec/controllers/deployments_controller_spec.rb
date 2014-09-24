require 'spec_helper'

describe DeploymentsController do

  let(:deployment) { deployments(:deployment1) }

  describe '#index' do

    it 'returns the deployments' do
      get :index, format: :json
      expect(response.body).to eq [deployment].to_json
    end

    it 'returns a 200 status code' do
      get :index, format: :json
      expect(response.status).to eq 200
    end
  end

  describe '#show' do

    before do
      Deployment.any_instance.stub(:status)
    end

    it 'returns the specified deployment' do
      get :show, id: deployment, format: :json
      expect(response.body).to eq DeploymentDetailSerializer.new(deployment).to_json
    end

    it 'returns a 200 status code' do
      get :show, id: deployment, format: :json
      expect(response.status).to eq 200
    end
  end

  describe '#create' do

    let(:template) { 'sometemplate' }

    before do
      Deployment.stub(:deploy).and_return(deployment)
    end

    it 'deploys the template' do
      expect(Deployment).to receive(:deploy).with(template)
      post :create, template: template, format: :json
    end

    it 'returns the new deployment' do
      post :create, template: template, format: :json
      expect(response.body).to eq deployment.to_json
    end

    it 'returns a 204 status code' do
      post :create, template: template, format: :json
      expect(response.status).to eq 201
    end
  end

  describe '#destroy' do

    before do
      Deployment.any_instance.stub(:undeploy_services)
    end

    it 'deletes the specified deployment' do
      expect do
        delete :destroy, id: deployment, format: :json
      end.to change(Deployment, :count).by(-1)
    end

    it 'returns a 204 status code' do
      delete :destroy, id: deployment, format: :json
      expect(response.status).to eq 204
    end

  end
end
