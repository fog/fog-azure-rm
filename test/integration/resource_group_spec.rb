require 'fog/azurerm'
require 'yaml'

# ResourceGroup integration test using RSpec

describe 'Integration testing of ResourceGroup' do
  before :all do
    azure_credentials = YAML.load_file(File.expand_path('credentials/azure.yml', __dir__))

    @resource_service = Fog::Resources::AzureRM.new(
      tenant_id: azure_credentials['tenant_id'],
      client_id: azure_credentials['client_id'],
      client_secret: azure_credentials['client_secret'],
      subscription_id: azure_credentials['subscription_id']
    )

    @resource_group_name = 'TestRG-RG'
    @location = 'eastus'
    @tags = { key1: 'value1', key2: 'value2' }
  end

  describe 'Create' do
    before :all do
      @resource_group = @resource_service.resource_groups.create(name: @resource_group_name, location: @location, tags: @tags)
    end

    it 'it\'s name is TestRG-RG' do
      expect(@resource_group.name).to eq(@resource_group_name)
    end

    it 'it\'s in eastus' do
      expect(@resource_group.location).to eq(@location)
    end

    it 'it\'s tag values are \'value1\' and \'value2\'' do
      expect(@resource_group.tags['key1']).to eq(@tags[:key1])
      expect(@resource_group.tags['key2']).to eq(@tags[:key2])
    end
  end

  describe 'Get' do
    before 'get resource group' do
      @resource_group = @resource_service.resource_groups.get(@resource_group_name)
    end

    it 'it\'s name is TestRG-RG' do
      expect(@resource_group.name).to eq(@resource_group_name)
    end

  end

  describe 'List' do
    before :all do
      @resource_group_list = @resource_service.resource_groups
    end

    it 'it\'s not empty' do
      expect(@resource_group_list.length).to_not eq(0)
    end

    it 'contains TestRG-RG' do
      contains_test_rg = false
      @resource_group_list.each do |resource_group|
        contains_test_rg = true if resource_group.name == 'TestRG-RG'
      end
      expect(contains_test_rg).to eq(true)
    end
  end

  describe 'Delete' do
    before 'get resource group' do
      @resource_group = @resource_service.resource_groups.get(@resource_group_name)
    end

    it 'it\'s deleted' do
      expect(@resource_group.destroy).to eq(true)
    end
  end
end