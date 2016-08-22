require File.expand_path '../../test_helper', __dir__

# Test class for List Virtual Network Gateways Request
class TestListVirtualNetwrokGateways < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    client = @service.instance_variable_get(:@network_client)
    @network_gateways = client.virtual_network_gateways
    @promise = Concurrent::Promise.execute do
    end
  end

  def test_list_virtual_network_gateways_success
    mocked_response = ApiStub::Requests::Network::VirtualNetworkGateway.list_virtual_network_gateway_response
    expected_response = Azure::ARM::Network::Models::VirtualNetworkGatewayListResult.serialize_object(mocked_response.body)
    @promise.stub :value!, mocked_response do
      @network_gateways.stub :list, @promise do
        assert_equal @service.list_virtual_network_gateways('fog-test-rg'), expected_response['value']
      end
    end
  end

  def test_list_virtual_network_gateways_failure
    response = -> { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @promise.stub :value!, response do
      @network_gateways.stub :list, @promise do
        assert_raises(RuntimeError) { @service.list_virtual_network_gateways('fog-test-rg') }
      end
    end
  end
end
