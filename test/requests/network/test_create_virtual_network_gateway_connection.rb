require File.expand_path '../../test_helper', __dir__

# Test class for Create Virtual Network Gateway Connection Request
class TestCreateVirtualNetworkGatewayConnection < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    @network_client = @service.instance_variable_get(:@network_client)
    @gateway_connections = @network_client.virtual_network_gateway_connections
  end

  def test_create_virtual_network_gateway_connection_success
    network_gateway_parms = {}
    mocked_response = ApiStub::Requests::Network::VirtualNetworkGatewayConnection.create_virtual_network_gateway_connection_response(@network_client)
    @gateway_connections.stub :create_or_update, mocked_response do
      assert_equal @service.create_or_update_virtual_network_gateway_connection(network_gateway_parms), mocked_response
    end
  end

  def test_create_virtual_network_gateway_connection_argument_error_failure
    response = ApiStub::Requests::Network::VirtualNetworkGatewayConnection.create_virtual_network_gateway_connection_response(@network_client)
    @gateway_connections.stub :create_or_update, response do
      assert_raises ArgumentError do
        @service.create_or_update_virtual_network_gateway_connection
      end
    end
  end

  def test_create_virtual_network_gateway_connection_exception_failure
    network_gateway_parms = {}
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @gateway_connections.stub :create_or_update, response do
      assert_raises RuntimeError do
        @service.create_or_update_virtual_network_gateway_connection(network_gateway_parms)
      end
    end
  end
end
