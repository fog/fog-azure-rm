require File.expand_path '../../../test_helper', __FILE__

# Test class for Get Virtual Network Gateway Request
class TestGetVirtualNetworkGateway < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    @network_client = @service.instance_variable_get(:@network_client)
    @network_gateways = @network_client.virtual_network_gateways
  end

  def test_get_virtual_network_gateway_success
    mocked_response = ApiStub::Requests::Network::VirtualNetworkGateway.create_virtual_network_gateway_response(@network_client)
    @network_gateways.stub :get, mocked_response do
      assert_equal @service.get_virtual_network_gateway('fog-test-rg', 'fog-test-network-gateway'), mocked_response
    end
  end

  def test_get_virtual_network_gateway_failure
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @network_gateways.stub :get, response do
      assert_raises(RuntimeError) { @service.get_virtual_network_gateway('fog-test-rg', 'fog-test-network-gateway') }
    end
  end
end
