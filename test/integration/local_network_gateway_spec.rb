require 'fog/azurerm'
require 'yaml'

# Local Network Gateway Integration Test using RSpec

describe 'Integration Testing of Local Network Gateway' do
  before :all do
    azure_credentials = YAML.load_file(File.expand_path('credentials/azure.yml', __dir__))

    @resource = Fog::Resources::AzureRM.new(
      tenant_id: azure_credentials['tenant_id'],
      client_id: azure_credentials['client_id'],
      client_secret: azure_credentials['client_secret'],
      subscription_id: azure_credentials['subscription_id']
    )

    @network = Fog::Network::AzureRM.new(
      tenant_id: azure_credentials['tenant_id'],
      client_id: azure_credentials['client_id'],
      client_secret: azure_credentials['client_secret'],
      subscription_id: azure_credentials['subscription_id']
    )

    @location = 'eastus'
    @local_net_gateway_name = 'testLocalNetGateway'

    @resource_group = @resource.resource_groups.create(
      name: 'TestRG-LNG',
      location: @location
    )
  end

  describe 'Check Existence' do
    before 'checks existence of local network gateway' do
      @lng_exists = @network.local_network_gateways.check_local_net_gateway_exists(@resource_group.name, @local_net_gateway_name)
    end

    it 'should not exist yet' do
      expect(@lng_exists).to eq(false)
    end
  end

  describe 'Create' do
    before :all do
      @tags = {
        key1: 'value1',
        key2: 'value2'
      }
      @gateway_ip = '192.168.1.1'
      @asn = 100
      @bgp_peering_address = '192.168.1.2'
      @peer_weight = 3

      @local_network_gateway = @network.local_network_gateways.create(
        name: @local_net_gateway_name,
        location: @location,
        tags: @tags,
        resource_group: @resource_group.name,
        gateway_ip_address: @gateway_ip,
        local_network_address_space_prefixes: [],
        asn: @asn,
        bgp_peering_address: @bgp_peering_address,
        peer_weight: @peer_weight
      )
    end

    it 'should have name: \'testLocalNetGateway\'' do
      expect(@local_network_gateway.name).to eq(@local_net_gateway_name)
    end

    it 'should belong to resource group: \'TestRG-LNG\'' do
      expect(@local_network_gateway.resource_group).to eq(@resource_group.name)
    end

    it 'should exist in location: \'eastus\'' do
      expect(@local_network_gateway.location).to eq(@location)
    end

    it 'should have gateway IP address: \'192.168.1.1\'' do
      expect(@local_network_gateway.gateway_ip_address).to eq(@gateway_ip)
    end

    it 'should have peer weight: \'3\'' do
      expect(@local_network_gateway.peer_weight).to eq(@peer_weight)
    end

    it 'should have ASN: \'100\'' do
      expect(@local_network_gateway.asn).to eq(@asn)
    end

    it 'should have BPG peering address: \'192.168.1.2\'' do
      expect(@local_network_gateway.bgp_peering_address).to eq(@bgp_peering_address)
    end

    it 'should have no local network address space prefixes' do
      expect(@local_network_gateway.local_network_address_space_prefixes.empty?).to eq(true)
    end

    it 'should contain tag values \'value1\' and \'value2\'' do
      expect(@local_network_gateway.tags['key1']).to eq(@tags[:key1])
      expect(@local_network_gateway.tags['key2']).to eq(@tags[:key2])
    end
  end

  describe 'Get' do
    before 'gets network security rule' do
      @local_network_gateway = @network.local_network_gateways.get(@resource_group.name, @local_net_gateway_name)
    end

    it 'should have name: \'testLocalNetGateway\'' do
      expect(@local_network_gateway.name).to eq(@local_net_gateway_name)
    end
  end

  describe 'List' do
    before :all do
      @local_network_gateways = @network.local_network_gateways(resource_group: @resource_group.name)
    end

    it 'should not be empty' do
      expect(@local_network_gateways.length).to_not eq(0)
    end

    it 'should contain local network gateway: \'testLocalNetGateway\'' do
      contains_lng = false
      @local_network_gateways.each do |gateway|
        contains_lng = true if gateway.name == @local_net_gateway_name
      end
      expect(contains_lng).to eq(true)
    end
  end

  describe 'Delete' do
    before 'gets local network gateway' do
      @local_network_gateway = @network.local_network_gateways.get(@resource_group.name, @local_net_gateway_name)
    end

    it 'should not exist anymore' do
      expect(@local_network_gateway.destroy).to eq(true)
      expect(@resource_group.destroy).to eq(true)
    end
  end
end
