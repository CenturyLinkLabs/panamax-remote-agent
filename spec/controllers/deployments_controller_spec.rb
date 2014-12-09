require 'spec_helper'

describe DeploymentsController do

  let(:deployment) { deployments(:deployment1) }

  describe '#index' do

    it 'returns the deployments' do
      get :index, format: :json
      json = ActiveModel::ArraySerializer.new([deployment], each_serializer: DeploymentSerializer).to_json
      expect(response.body).to eq json
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

    let(:template) { { 'name' => 'template1' } }
    let(:override) { { 'name' => 'deployment1' } }

    before do
      Deployment.stub(:deploy).and_return(deployment)
    end

    it 'deploys the template' do
      expect(Deployment).to receive(:deploy) do |t,d|
        expect(t.name).to eq template['name']
        expect(d.name).to eq override['name']
        deployment
      end

      post :create, template: template, override: override, format: :json
    end

    it 'returns the new deployment' do
      post :create, template: template, override: override, format: :json
      expect(response.body).to eq DeploymentSerializer.new(deployment).to_json
    end

    it 'returns a 204 status code' do
      post :create, template: template, override: override, format: :json
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

  describe '#redeploy' do

    context 'when the deployment is redeployable' do
      let(:deployment_template) { { 'name' => 'some template' }.to_json }
      before do
        deployment.template = deployment_template
        allow(deployment).to receive(:destroy) { true }
        allow(Deployment).to receive(:find) { deployment }
      end

      it 'destroys the deployment' do
        expect(deployment).to receive(:destroy)
        post :redeploy, id: deployment, format: :json
      end

      it 'creates a new template from the old deployment template' do
        expect(Template).to receive(:new).with(JSON.parse(deployment_template))
        post :redeploy, id: deployment, format: :json
      end

      it 'creates a new deployment using the old deployment template' do
        expect(Deployment).to receive(:deploy) do |t|
          expect(t.name).to eq 'some template'
        end
        post :redeploy, id: deployment, format: :json
      end
    end

    context 'when the deployment is not redeployable' do
      before do
        allow(deployment).to receive(:redeployable?) { false }
      end

      it 'returns a 500 status code' do
        post :redeploy, id: deployment, format: :json
        expect(response.status).to eq 500
      end

      it 'includes' do
        post :redeploy, id: deployment, format: :json
        expect(response.body).to eq({ message: I18n.t(:not_redeployable_error, deployment: deployment.name) }.to_json)
      end
    end
  end
end
