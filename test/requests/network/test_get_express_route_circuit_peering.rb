require File.expand_path '../../test_helper', __dir__

# Test class for Get Express Route Circuit Peering Request
class TestGetExpressRouteCircuitPeering < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    client = @service.instance_variable_get(:@network_client)
    @circuit_peering = client.express_route_circuit_peerings
    @promise = Concurrent::Promise.execute do
    end
  end

  def test_get_express_route_circuit_peering_success
    mocked_response = ApiStub::Requests::Network::ExpressRouteCircuitPeering.create_express_route_circuit_peering_response
    expected_response = Azure::ARM::Network::Models::ExpressRouteCircuitPeering.serialize_object(mocked_response.body)
    @promise.stub :value!, mocked_response do
      @circuit_peering.stub :get, @promise do
        assert_equal @service.get_express_route_circuit_peering('Fog-rg', 'AzurePrivatePeering', 'testCircuit'), expected_response
      end
    end
  end

  def test_get_express_route_circuit_peering_failure
    response = -> { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @promise.stub :value!, response do
      @circuit_peering.stub :get, @promise do
        assert_raises(RuntimeError) { @service.get_express_route_circuit_peering('Fog-rg', 'AzurePrivatePeering', 'testCircuit') }
      end
    end
  end
end
