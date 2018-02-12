require File.expand_path '../../test_helper', __dir__

# Test class for Get Local Network Gateway Request
class TestGetLocalNetworkGateway < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    @network_client = @service.instance_variable_get(:@network_client)
    @local_network_gateways = @network_client.local_network_gateways
  end

  def test_get_local_network_gateway_success
    mocked_response = ApiStub::Requests::Network::LocalNetworkGateway.create_local_network_gateway_response(@network_client)
    @local_network_gateways.stub :get, mocked_response do
      assert_equal @service.get_local_network_gateway('fog-test-rg', 'fog-test-local-network-gateway'), mocked_response
    end
  end

  def test_get_local_network_gateway_failure
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @local_network_gateways.stub :get, response do
      assert_raises(MsRestAzure::AzureOperationError) { @service.get_local_network_gateway('fog-test-rg', 'fog-test-local-network-gateway') }
    end
  end
end
