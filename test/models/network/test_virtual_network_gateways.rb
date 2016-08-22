require File.expand_path '../../test_helper', __dir__

# Test class for VirtualNetworkGateway Collection
class TestVirtualNetworkGateways < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    @network_gateways = Fog::Network::AzureRM::VirtualNetworkGateways.new(resource_group: 'fog-rg', service: @service)
  end

  def test_collection_methods
    methods = [
        :all,
        :get
    ]
    methods.each do |method|
      assert @network_gateways.respond_to? method
    end
  end

  def test_collection_attributes
    assert @network_gateways.respond_to? :resource_group
  end

  def test_all_method_response
    response = [ApiStub::Models::Network::VirtualNetworkGateway.create_virtual_network_gateway_response]
    @service.stub :list_virtual_network_gateways, response do
      assert_instance_of Fog::Network::AzureRM::VirtualNetworkGateways, @network_gateways.all
      assert @network_gateways.all.size >= 1
      @network_gateways.all.each do |network_gateway|
        assert_instance_of Fog::Network::AzureRM::VirtualNetworkGateway, network_gateway
      end
    end
  end

  def test_get_method_response
    response = ApiStub::Models::Network::VirtualNetworkGateway.create_virtual_network_gateway_response
    @service.stub :get_virtual_network_gateway, response do
      assert_instance_of Fog::Network::AzureRM::VirtualNetworkGateway, @network_gateways.get('fog-rg', 'myvirtualgateway1')
    end
  end
end
