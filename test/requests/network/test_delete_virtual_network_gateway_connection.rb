require File.expand_path '../../test_helper', __dir__

# Test class for Delete Virtual Network Gateway Connection Request
class TestDeleteVirtualNetworkGatewayConnection < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    client = @service.instance_variable_get(:@network_client)
    @gateway_connections = client.virtual_network_gateway_connections
  end

  def test_delete_virtual_network_gateway_connection_success
    response = ApiStub::Requests::Network::VirtualNetworkGatewayConnection.delete_virtual_network_gateway_connection_response
    @gateway_connections.stub :delete, response do
      assert @service.delete_virtual_network_gateway_connection('fog-test-rg', 'fog-test-gateway-connection'), response
    end
  end

  def test_delete_virtual_network_gateway_connection_failure
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @gateway_connections.stub :delete, response do
      assert_raises(RuntimeError) { @service.delete_virtual_network_gateway_connection('fog-test-rg', 'fog-test-gateway-connection') }
    end
  end
end
