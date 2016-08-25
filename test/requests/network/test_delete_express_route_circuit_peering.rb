require File.expand_path '../../test_helper', __dir__

# Test class for Delete Express Route Circuit Peering Request
class TestDeleteExpressRouteCircuitPeering < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    client = @service.instance_variable_get(:@network_client)
    @circuit_peering = client.express_route_circuit_peerings
    @promise = Concurrent::Promise.execute do
    end
  end

  def test_delete_express_route_circuit_peering_success
    response = true
    @promise.stub :value!, response do
      @circuit_peering.stub :delete, @promise do
        assert @service.delete_express_route_circuit_peering('Fog-rg', 'AzurePrivatePeering', 'testCircuit'), response
      end
    end
  end

  def test_delete_express_route_circuit_peering_failure
    response = -> { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @promise.stub :value!, response do
      @circuit_peering.stub :delete, @promise do
        assert_raises(RuntimeError) { @service.delete_express_route_circuit_peering('Fog-rg', 'AzurePrivatePeering', 'testCircuit') }
      end
    end
  end
end
