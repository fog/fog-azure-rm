require File.expand_path '../../test_helper', __dir__

# Test class for Set Connection Shared Key Request
class TestResetConnectionSharedKey < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    @network_client = @service.instance_variable_get(:@network_client)
    @gateway_connections = @network_client.virtual_network_gateway_connections
  end

  def test_reset_connection_shared_key_success
    mocked_response = ApiStub::Requests::Network::VirtualNetworkGatewayConnection.reset_connection_shared_key_response(@network_client)
    @gateway_connections.stub :reset_shared_key, mocked_response do
      assert_equal @service.reset_connection_shared_key('fog-test-rg', 'fog-test-gateway-connection', '20'), mocked_response.key_length
    end
  end

  def test_reset_connection_shared_key_failure
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @gateway_connections.stub :reset_shared_key, response do
      assert_raises(RuntimeError) { @service.reset_connection_shared_key('fog-test-rg', 'fog-test-gateway-connection', '20') }
    end
  end
end
