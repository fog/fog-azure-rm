require 'fog/azurerm'
require 'yaml'

# Public Ip integration test using RSpec

describe 'Integration testing of Public Ip' do
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

    @resource_group_name = 'TestRG-PB'
    @location = 'eastus'
    @public_ip_name = 'Test-Public-IP'
    @public_ip_allocation_method = 'Dynamic'
    @domain_label = 'newdomainlabel'
    @resource_group = @resource_service.resource_groups.create(name: @resource_group_name, location: @location)
  end

  describe 'Check Existence' do
    before :all do
      @public_ip_exits = @network_service.public_ips.check_public_ip_exists(@resource_group_name, @public_ip_name)
    end

    context 'Public Ip' do
      it 'should not exist yet' do
        expect(@public_ip_exits).to eq(false)
      end
    end
  end

  describe 'Create' do
    before :all do
      @tags = { key1: 'value1', key2: 'value2' }
      @public_ip = @network_service.public_ips.create(
        name: @public_ip_name,
        resource_group: @resource_group_name,
        location: @location,
        public_ip_allocation_method: Fog::ARM::Network::Models::IPAllocationMethod::Dynamic,
        tags: @tags
      )
    end

    it 'it\'s name is Test-Public-IP' do
      expect(@public_ip.name).to eq(@public_ip_name)
    end

    it 'should exist in resource group: \'TestRG-PB\'' do
      expect(@public_ip.resource_group).to eq(@resource_group_name)
    end

    it 'it\'s in eastus' do
      expect(@public_ip.location).to eq(@location)
    end

    it 'it\'s tag values are \'value1\' and \'value2\'' do
      expect(@public_ip.tags['key1']).to eq(@tags[:key1])
      expect(@public_ip.tags['key2']).to eq(@tags[:key2])
    end

    it 'it\'s idle timeout in minutes is \'4\'' do
      expect(@public_ip.idle_timeout_in_minutes).to eq(4)
    end

    it 'it\'s public IP allocation method is \'Dynamic\'' do
      expect(@public_ip.public_ip_allocation_method).to eq(@public_ip_allocation_method)
    end

    it 'it\'s domain name label is \'nil\'' do
      expect(@public_ip.domain_name_label).to eq(nil)
    end
  end

  describe 'Get' do
    before :all do
      @public_ip = @network_service.public_ips.get(@resource_group_name, @public_ip_name)
    end

    it 'should have name: \'Test-Public-IP\'' do
      expect(@public_ip.name).to eq(@public_ip_name)
    end
  end

  describe 'Update' do
    before :all do
      @public_ip = @network_service.public_ips.get(@resource_group_name, @public_ip_name)
      @public_ip.update(
        public_ip_allocation_method: Fog::ARM::Network::Models::IPAllocationMethod::Dynamic,
        idle_timeout_in_minutes: '10',
        domain_name_label: @domain_label
      )
    end

    it 'it\'s idle timeout in minutes is \'10\'' do
      expect(@public_ip.idle_timeout_in_minutes).to eq(10)
    end

    it 'it\'s public IP allocation method is \'Dynamic\'' do
      expect(@public_ip.public_ip_allocation_method).to eq(@public_ip_allocation_method)
    end

    it 'it\'s domain name label is \'newdomainlabel\'' do
      expect(@public_ip.domain_name_label).to eq(@domain_label)
    end
  end

  describe 'Delete' do
    before :all do
      @public_ip = @network_service.public_ips.get(@resource_group_name, @public_ip_name)
    end

    it 'should not exist anymore' do
      expect(@public_ip.destroy).to eq(true)
      expect(@resource_group.destroy).to eq(true)
    end
  end
end
