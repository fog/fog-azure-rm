require File.expand_path '../../test_helper', __dir__

# Test class for VirtualNetworkGateway Collection
class TestVirtualNetworkGateways < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    @network_gateways = Fog::Network::AzureRM::VirtualNetworkGateways.new(resource_group: 'fog-rg', service: @service)
    @network_client = @service.instance_variable_get(:@network_client)
  end

  def test_collection_methods
    methods = [
      :all,
      :get,
      :check_vnet_gateway_exists
    ]
    methods.each do |method|
      assert_respond_to @network_gateways, method
    end
  end

  def test_collection_attributes
    assert_respond_to @network_gateways, :resource_group
  end

  def test_all_method_response
    response = [ApiStub::Models::Network::VirtualNetworkGateway.create_virtual_network_gateway_response(@network_client)]
    @service.stub :list_virtual_network_gateways, response do
      assert_instance_of Fog::Network::AzureRM::VirtualNetworkGateways, @network_gateways.all
      assert @network_gateways.all.size >= 1
      @network_gateways.all.each do |network_gateway|
        assert_instance_of Fog::Network::AzureRM::VirtualNetworkGateway, network_gateway
      end
    end
  end

  def test_get_method_response
    response = ApiStub::Models::Network::VirtualNetworkGateway.create_virtual_network_gateway_response(@network_client)
    @service.stub :get_virtual_network_gateway, response do
      assert_instance_of Fog::Network::AzureRM::VirtualNetworkGateway, @network_gateways.get('fog-rg', 'myvirtualgateway1')
    end
  end

  def test_check_vnet_gateway_exists_true_response
    @service.stub :check_vnet_gateway_exists, true do
      assert @network_gateways.check_vnet_gateway_exists('fog-rg', 'myvirtualgateway1')
    end
  end

  def test_check_vnet_gateway_exists_false_response
    @service.stub :check_vnet_gateway_exists, false do
      assert !@network_gateways.check_vnet_gateway_exists('fog-rg', 'myvirtualgateway1')
    end
  end
end
