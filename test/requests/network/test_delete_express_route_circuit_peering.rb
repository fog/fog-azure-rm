require File.expand_path '../../test_helper', __dir__

# Test class for Delete Express Route Circuit Peering Request
class TestDeleteExpressRouteCircuitPeering < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    @network_client = @service.instance_variable_get(:@network_client)
    @circuit_peering = @network_client.express_route_circuit_peerings
  end

  def test_delete_express_route_circuit_peering_success
    response = true
    @circuit_peering.stub :delete, response do
      assert @service.delete_express_route_circuit_peering('Fog-rg', 'AzurePrivatePeering', 'testCircuit'), response
    end
  end

  def test_delete_express_route_circuit_peering_failure
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @circuit_peering.stub :delete, response do
      assert_raises(MsRestAzure::AzureOperationError) { @service.delete_express_route_circuit_peering('Fog-rg', 'AzurePrivatePeering', 'testCircuit') }
    end
  end
end
