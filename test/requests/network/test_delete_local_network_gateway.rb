require File.expand_path '../../test_helper', __dir__

# Test class for Delete Local Network Gateway Request
class TestDeleteLocalNetworkGateway < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    network_client = @service.instance_variable_get(:@network_client)
    @local_network_gateways = network_client.local_network_gateways
  end

  def test_delete_local_network_gateway_success
    @local_network_gateways.stub :delete, true do
      assert @service.delete_local_network_gateway('fog-test-rg', 'fog-test-local-network-gateway')
    end
  end

  def test_delete_local_network_gateway_failure
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @local_network_gateways.stub :delete, response do
      assert_raises(MsRestAzure::AzureOperationError) { @service.delete_local_network_gateway('fog-test-rg', 'fog-test-local-network-gateway') }
    end
  end
end
