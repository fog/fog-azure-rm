require File.expand_path '../../test_helper', __dir__

# Test class for Get Express Route Circuit Peering Request
class TestGetExpressRouteCircuitPeering < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    @network_client = @service.instance_variable_get(:@network_client)
    @circuit_peering = @network_client.express_route_circuit_peerings
  end

  def test_get_express_route_circuit_peering_success
    mocked_response = ApiStub::Requests::Network::ExpressRouteCircuitPeering.create_express_route_circuit_peering_response(@network_client)
    @circuit_peering.stub :get, mocked_response do
      assert_equal @service.get_express_route_circuit_peering('Fog-rg', 'AzurePrivatePeering', 'testCircuit'), mocked_response
    end
  end

  def test_get_express_route_circuit_peering_failure
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @circuit_peering.stub :get, response do
      assert_raises(RuntimeError) { @service.get_express_route_circuit_peering('Fog-rg', 'AzurePrivatePeering', 'testCircuit') }
    end
  end
end
