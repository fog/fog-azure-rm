require File.expand_path '../../test_helper', __dir__

# Test class for Get Connection Shared Key Request
class TestGetConnectionSharedKey < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    @network_client = @service.instance_variable_get(:@network_client)
    @gateway_connections = @network_client.virtual_network_gateway_connections
  end

  def test_get_connection_shared_key_success
    mocked_response = ApiStub::Requests::Network::VirtualNetworkGatewayConnection.get_connection_shared_key_response(@network_client)
    @gateway_connections.stub :get_shared_key, mocked_response do
      assert_equal @service.get_connection_shared_key('fog-test-rg', 'fog-test-gateway-connection'), mocked_response.value
    end
  end

  def test_get_connection_shared_key_failure
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @gateway_connections.stub :get_shared_key, response do
      assert_raises(MsRestAzure::AzureOperationError) { @service.get_connection_shared_key('fog-test-rg', 'fog-test-gateway-connection') }
    end
  end
end
