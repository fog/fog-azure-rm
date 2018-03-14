require File.expand_path '../../test_helper', __dir__

# Test class for Get Virtual Network Gateway Connection Request
class TestGetVirtualNetworkGatewayConnection < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    @network_client = @service.instance_variable_get(:@network_client)
    @gateway_connections = @network_client.virtual_network_gateway_connections
  end

  def test_get_virtual_network_gateway_connection_success
    mocked_response = ApiStub::Requests::Network::VirtualNetworkGatewayConnection.create_virtual_network_gateway_connection_response(@network_client)
    @gateway_connections.stub :get, mocked_response do
      assert_equal @service.get_virtual_network_gateway_connection('fog-test-rg', 'fog-test-gateway-connection'), mocked_response
    end
  end

  def test_get_virtual_network_gateway_connection_failure
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @gateway_connections.stub :get, response do
      assert_raises(MsRestAzure::AzureOperationError) { @service.get_virtual_network_gateway_connection('fog-test-rg', 'fog-test-gateway-connection') }
    end
  end
end
