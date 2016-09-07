require File.expand_path '../../test_helper', __dir__

# Test class for VirtualNetworkGatewayConnection Collection
class TestVirtualNetworkGatewayConnections < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    @gateway_connections = Fog::Network::AzureRM::VirtualNetworkGatewayConnections.new(resource_group: 'fog-rg', service: @service)
    @network_client = @service.instance_variable_get(:@network_client)
  end

  def test_collection_methods
    methods = [
        :all,
        :get
    ]
    methods.each do |method|
      assert @gateway_connections.respond_to? method
    end
  end

  def test_collection_attributes
    assert @gateway_connections.respond_to? :resource_group
  end

  def test_all_method_response
    response = [ApiStub::Models::Network::VirtualNetworkGatewayConnection.create_virtual_network_gateway_connection_response(@network_client)]
    @service.stub :list_virtual_network_gateway_connections, response do
      assert_instance_of Fog::Network::AzureRM::VirtualNetworkGatewayConnections, @gateway_connections.all
      assert @gateway_connections.all.size >= 1
      @gateway_connections.all.each do |gateway_connection|
        assert_instance_of Fog::Network::AzureRM::VirtualNetworkGatewayConnection, gateway_connection
      end
    end
  end

  def test_get_method_response
    response = ApiStub::Models::Network::VirtualNetworkGatewayConnection.create_virtual_network_gateway_connection_response(@network_client)
    @service.stub :get_virtual_network_gateway_connection, response do
      assert_instance_of Fog::Network::AzureRM::VirtualNetworkGatewayConnection, @gateway_connections.get('fog-rg', 'cn1')
    end
  end
end
