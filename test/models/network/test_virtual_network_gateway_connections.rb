require File.expand_path '../../test_helper', __dir__

# Test class for VirtualNetworkGatewayConnection Collection
class TestVirtualNetworkGatewayConnections < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    @gateway_connections = Fog::Network::AzureRM::VirtualNetworkGatewayConnections.new(resource_group: 'fog-rg', service: @service)
    @network_client = @service.instance_variable_get(:@network_client)
    @response = ApiStub::Models::Network::VirtualNetworkGatewayConnection.create_virtual_network_gateway_connection_response(@network_client)
  end

  def test_collection_methods
    methods = [
      :all,
      :get,
      :check_vnet_gateway_connection_exists
    ]
    methods.each do |method|
      assert_respond_to @gateway_connections, method
    end
  end

  def test_collection_attributes
    assert_respond_to @gateway_connections, :resource_group
  end

  def test_all_method_response
    connection_response = [@response]
    @service.stub :list_virtual_network_gateway_connections, connection_response do
      assert_instance_of Fog::Network::AzureRM::VirtualNetworkGatewayConnections, @gateway_connections.all
      assert @gateway_connections.all.size >= 1
      @gateway_connections.all.each do |gateway_connection|
        assert_instance_of Fog::Network::AzureRM::VirtualNetworkGatewayConnection, gateway_connection
      end
    end
  end

  def test_get_method_response
    @service.stub :get_virtual_network_gateway_connection, @response do
      assert_instance_of Fog::Network::AzureRM::VirtualNetworkGatewayConnection, @gateway_connections.get('fog-rg', 'cn1')
    end
  end

  def test_check_vnet_gateway_connection_exists_true_response
    @service.stub :check_vnet_gateway_connection_exists, true do
      assert @gateway_connections.check_vnet_gateway_connection_exists('fog-rg', 'cn1')
    end
  end

  def test_check_vnet_gateway_connection_exists_false_response
    @service.stub :check_vnet_gateway_connection_exists, false do
      assert !@gateway_connections.check_vnet_gateway_connection_exists('fog-rg', 'cn1')
    end
  end
end
