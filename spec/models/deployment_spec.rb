require 'spec_helper'

describe Deployment do

  let(:client) { double(:client) }
  let(:service_ids) { ['a.svc', 'b.svc'] }

  subject { described_class.new(service_ids: service_ids) }

  before do
    OrchestrationAdapter::Client.stub(:new).and_return(client)
  end

  describe 'attributes' do
    it { should respond_to :name }
    it { should respond_to :template }
    it { should respond_to :service_ids }
  end

  describe '.deploy' do

    let(:template) { "images:\n- name: a\n  source: b\n- name: c\n  source: d" }
    let(:template) do
      Template.new(
        'images' => [{ 'name' => 'image1' }, { 'name' => 'image2' }]
      )
    end

    let(:override) do
      Template.new(
        'images' => [{ 'name' => 'image1', 'deployment' => { 'count' => 2 } }]
      )
    end

    let(:deployed_services) { [{ 'id' => 'a.svc' }, { 'id' => 'b.svc' }] }

    before do
      client.stub(:create_services).and_return(deployed_services)
    end

    it 'overrides the template with the deployment descriptor' do
      expect(template).to receive(:override).with(override)
      described_class.deploy(template, override)
    end

    it 'calls create_services on the client' do
      expect(client).to receive(:create_services) do |services|
        expect(services).to have(template.images.count).items
        expect(services.first).to be_kind_of ImageSerializer
        deployed_services
      end

      described_class.deploy(template, override)
    end

    it 'returns a Deployment instance' do
      deployment = described_class.deploy(template, override)
      expect(deployment).to be_a Deployment
    end

    it 'populates the service IDs in the Deployment instance' do
      deployment = described_class.deploy(template, override)
      expect(deployment.service_ids).to eq ['a.svc', 'b.svc']
    end

    it 'persists the Deployment instance' do
      expect(described_class.deploy(template, override).persisted?).to eq true
    end

    it 'persists the name of the template to the Deployment instance' do
      template.name = 'foo'
      expect(described_class.deploy(template, override).name).to eq template.name
    end
  end

  describe '#stop' do

    before do
      client.stub(:update_service)
    end

    it 'stops each of the deployment services' do
      service_ids.each do |service_id|
        expect(client).to receive(:update_service).with(service_id, :stopped)
      end

      subject.stop
    end
  end

  describe '#start' do

    before do
      client.stub(:update_service)
    end

    it 'starts each of the deployment services' do
      service_ids.each do |service_id|
        expect(client).to receive(:update_service).with(service_id, :started)
      end

      subject.start
    end
  end

  describe '#destroy' do

    before do
      client.stub(:delete_service)
    end

    it 'deletes each of the deployment services' do
      service_ids.each do |service_id|
        expect(client).to receive(:delete_service).with(service_id)
      end

      subject.destroy
    end
  end

  describe '#status' do

    let(:service_a) { { 'id' => 'a.svc', 'actualState' => 'started' } }
    let(:service_b) { { 'id' => 'b.svc', 'actualState' => 'stopped' } }

    before do
      client.stub(:get_service).with('a.svc').and_return(service_a)
      client.stub(:get_service).with('b.svc').and_return(service_b)
    end

    it 'retrieves the status for each deployment service' do
      service_ids.each do |service_id|
        expect(client).to receive(:get_service).with(service_id)
      end

      subject.status
    end

    it 'returns the individual service status results' do
      expect(subject.status[:services]).to eq [service_a, service_b]
    end

  end
end
