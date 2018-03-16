require 'fog/azurerm'
require 'yaml'

# Resource Tag integration test using RSpec

describe 'Integration testing of Resource Tag' do
  before :all do
    azure_credentials = YAML.load_file(File.expand_path('credentials/azure.yml', __dir__))

    @resource_service = Fog::Resources::AzureRM.new(
      tenant_id: azure_credentials['tenant_id'],
      client_id: azure_credentials['client_id'],
      client_secret: azure_credentials['client_secret'],
      subscription_id: azure_credentials['subscription_id']
    )

    @network_service = Fog::Network::AzureRM.new(
      tenant_id: azure_credentials['tenant_id'],
      client_id: azure_credentials['client_id'],
      client_secret: azure_credentials['client_secret'],
      subscription_id: azure_credentials['subscription_id']
    )

    @resource_group_name = 'TestRG-RT'
    @location = 'eastus'
    @resource_name = 'Test-Public-IP'
    @resource_group = @resource_service.resource_groups.create(name: @resource_group_name, location: @location)
    @resource_id = @network_service.public_ips.create(
      name: @resource_name,
      resource_group: @resource_group_name,
      location: @location,
      public_ip_allocation_method: Fog::ARM::Network::Models::IPAllocationMethod::Dynamic
    ).id
  end

  describe 'Check Existence' do
    before :all do
      @resource_exits = @resource_service.azure_resources.check_azure_resource_exists(@resource_id, '2016-09-01')
    end

    context 'Azure Resource' do
      it 'should exist' do
        expect(@resource_exits).to eq(false)
      end
    end
  end

  describe 'Tag Resource' do
    before :all do
      @tag_resource = @resource_service.tag_resource(
        @resource_id,
        'test-key',
        'test-value',
        '2016-06-01'
      )
    end

    it 'Resource should be tagged' do
      expect(@tag_resource).to eq(true)
    end
  end

  describe 'Get' do
    before :all do
      @resources = @resource_service.azure_resources(tag_name: 'test-key', tag_value: 'test-value')
      @resource = @resource_service.azure_resources(tag_name: 'test-key').get(@resource_id)
    end

    it 'should have resources' do
      expect(@resources.length).not_to eq(0)
    end

    it 'should have a resource attached' do
      expect(@resource.id).to eq(@resource_id)
    end
  end

  describe 'Delete' do
    before :all do
      @public_ip = @network_service.public_ips.get(@resource_group_name, @resource_name)
      @resource_tag_removed = @resource_service.delete_resource_tag(
        @resource_id,
        'test-key',
        'test-value',
        '2016-06-01'
      )
    end

    it 'should not exist anymore' do
      expect(@resource_tag_removed).to eq(true)
      expect(@public_ip.destroy).to eq(true)
      expect(@resource_group.destroy).to eq(true)
    end
  end
end
