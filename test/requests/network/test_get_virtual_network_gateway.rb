require File.expand_path '../../test_helper', __dir__

# Test class for Get Virtual Network Gateway Request
class TestGetVirtualNetworkGateway < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    client = @service.instance_variable_get(:@network_client)
    @network_gateways = client.virtual_network_gateways
    @promise = Concurrent::Promise.execute do
    end
  end

  def test_get_virtual_network_gateway_success
    mocked_response = ApiStub::Requests::Network::VirtualNetworkGateway.create_virtual_network_gateway_response
    expected_response = Azure::ARM::Network::Models::VirtualNetworkGateway.serialize_object(mocked_response.body)
    @promise.stub :value!, mocked_response do
      @network_gateways.stub :get, @promise do
        assert_equal @service.get_virtual_network_gateway('fog-test-rg', 'fog-test-network-gateway'), expected_response
      end
    end
  end

  def test_get_virtual_network_gateway_failure
    response = -> { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @promise.stub :value!, response do
      @network_gateways.stub :get, @promise do
        assert_raises(RuntimeError) { @service.get_virtual_network_gateway('fog-test-rg', 'fog-test-network-gateway') }
      end
    end
  end
end
