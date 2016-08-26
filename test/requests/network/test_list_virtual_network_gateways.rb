require File.expand_path '../../test_helper', __dir__

# Test class for List Virtual Network Gateways Request
class TestListVirtualNetwrokGateways < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    @network_client = @service.instance_variable_get(:@network_client)
    @network_gateways = @network_client.virtual_network_gateways
  end

  def test_list_virtual_network_gateways_success
    mocked_response = ApiStub::Requests::Network::VirtualNetworkGateway.list_virtual_network_gateway_response(@network_client)
    @network_gateways.stub :list_as_lazy, mocked_response do
      assert_equal @service.list_virtual_network_gateways('fog-test-rg'), mocked_response.value
    end
  end

  def test_list_virtual_network_gateways_failure
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @network_gateways.stub :list_as_lazy, response do
      assert_raises(RuntimeError) { @service.list_virtual_network_gateways('fog-test-rg') }
    end
  end
end
