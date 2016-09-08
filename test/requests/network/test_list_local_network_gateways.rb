require File.expand_path '../../test_helper', __dir__

# Test class for List Local Network Gateways Request
class TestListLocalNetwrokGateways < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    @network_client = @service.instance_variable_get(:@network_client)
    @local_network_gateways = @network_client.local_network_gateways
  end

  def test_list_local_network_gateways_success
    mocked_response = ApiStub::Requests::Network::LocalNetworkGateway.list_local_network_gateway_response
    @local_network_gateways.stub :list_as_lazy, mocked_response do
      assert_equal @service.list_local_network_gateways('fog-test-rg'), mocked_response.value
    end
  end

  def test_list_local_network_gateways_failure
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @local_network_gateways.stub :list_as_lazy, response do
      assert_raises(RuntimeError) { @service.list_local_network_gateways('fog-test-rg') }
    end
  end
end
