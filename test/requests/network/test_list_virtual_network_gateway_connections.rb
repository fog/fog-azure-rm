require File.expand_path '../../test_helper', __dir__

# Test class for List Virtual Network Gateway Connections Request
class TestListVirtualNetwrokGatewayConnections < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    @network_client = @service.instance_variable_get(:@network_client)
    @gateway_connections = @network_client.virtual_network_gateway_connections
  end

  def test_list_virtual_network_gateway_connections_success
    mocked_response = ApiStub::Requests::Network::VirtualNetworkGatewayConnection.list_virtual_network_gateway_connection_response(@network_client)
    @gateway_connections.stub :list_as_lazy, mocked_response do
      assert_equal @service.list_virtual_network_gateway_connections('fog-test-rg'), mocked_response.value
    end
  end

  def test_list_virtual_network_gateway_connections_failure
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @gateway_connections.stub :list_as_lazy, response do
      assert_raises(MsRestAzure::AzureOperationError) { @service.list_virtual_network_gateway_connections('fog-test-rg') }
    end
  end
end
