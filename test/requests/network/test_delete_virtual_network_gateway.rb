require File.expand_path '../../test_helper', __dir__

# Test class for Delete Virtual Network Gateway Request
class TestDeleteVirtualNetworkGateway < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    client = @service.instance_variable_get(:@network_client)
    @network_gateways = client.virtual_network_gateways
  end

  def test_delete_virtual_network_gateway_success
    response = ApiStub::Requests::Network::VirtualNetworkGateway.delete_virtual_network_gateway_response
    @network_gateways.stub :delete, response do
      assert @service.delete_virtual_network_gateway('fog-test-rg', 'fog-test-network-gateway'), response
    end
  end

  def test_delete_virtual_network_gateway_failure
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @network_gateways.stub :delete, response do
      assert_raises(MsRestAzure::AzureOperationError) { @service.delete_virtual_network_gateway('fog-test-rg', 'fog-test-network-gateway') }
    end
  end
end
