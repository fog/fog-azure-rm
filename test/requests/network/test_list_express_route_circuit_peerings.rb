require File.expand_path '../../test_helper', __dir__

# Test class for List Express Route Circuit Peeringss Request
class TestListExpressRouteCircuitPeerings < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    @network_client = @service.instance_variable_get(:@network_client)
    @circuit_peering = @network_client.express_route_circuit_peerings
  end

  def test_list_express_route_circuit_peerings_success
    mocked_response = ApiStub::Requests::Network::ExpressRouteCircuitPeering.list_express_route_circuit_peering_response(@network_client)
    @circuit_peering.stub :list, mocked_response do
      assert_equal @service.list_express_route_circuit_peerings('fogRM-rg', 'testCircuit'), mocked_response
    end
  end

  def test_list_express_route_circuit_peerings_failure
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @circuit_peering.stub :list, response do
      assert_raises(RuntimeError) { @service.list_express_route_circuit_peerings('fogRM-rg', 'testCircuit') }
    end
  end
end
