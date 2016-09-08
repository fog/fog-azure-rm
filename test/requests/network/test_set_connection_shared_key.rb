require File.expand_path '../../test_helper', __dir__

# Test class for Set Connection Shared Key Request
class TestSetConnectionSharedKey < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    @network_client = @service.instance_variable_get(:@network_client)
    @gateway_connections = @network_client.virtual_network_gateway_connections
  end

  def test_set_connection_shared_key_success
    @gateway_connections.stub :set_shared_key, nil do
      assert_equal @service.set_connection_shared_key('fog-test-rg', 'fog-test-gateway-connection', 'hello'), true
    end
  end

  def test_set_connection_shared_key_failure
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @gateway_connections.stub :set_shared_key, response do
      assert_raises(RuntimeError) { @service.set_connection_shared_key('fog-test-rg', 'fog-test-gateway-connection', 'hello') }
    end
  end
end
