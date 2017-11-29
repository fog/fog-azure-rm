require File.expand_path '../../test_helper', __dir__

# Test class for Check Virtual Network Gateway Connection Exists Request
class TestCheckVirtualNetworkGatewayConnectionExists < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    @network_client = @service.instance_variable_get(:@network_client)
    @gateway_connections = @network_client.virtual_network_gateway_connections
  end

  def test_check_vnet_gateway_connection_exists_success
    mocked_response = ApiStub::Requests::Network::VirtualNetworkGatewayConnection.create_virtual_network_gateway_connection_response(@network_client)
    @gateway_connections.stub :get, mocked_response do
      assert_equal @service.check_vnet_gateway_connection_exists('fog-test-rg', 'fog-test-gateway-connection'), true
    end
  end

  def test_check_vnet_gateway_connection_exists_failure
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, get_mock_response, 'error' => { 'message' => 'mocked exception', 'code' => 'ResourceNotFound' }) }
    @gateway_connections.stub :get, response do
      assert !@service.check_vnet_gateway_connection_exists('fog-test-rg', 'fog-test-gateway-connection')
    end
  end

  def test_check_vnet_gateway_connection_exists_exception
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, get_mock_response, 'error' => { 'message' => 'mocked exception', 'code' => 'ResourceGroupNotFound' }) }
    @gateway_connections.stub :get, response do
      assert !@service.check_vnet_gateway_connection_exists('fog-test-rg', 'fog-test-gateway-connection')
    end
  end
end
