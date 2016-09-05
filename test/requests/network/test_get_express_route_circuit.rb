require File.expand_path '../../test_helper', __dir__

# Test class for Get Express Route Circuit Request
class TestGetExpressRouteCircuit < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    @network_client = @service.instance_variable_get(:@network_client)
    @circuit = @network_client.express_route_circuits
  end

  def test_get_express_route_circuit_success
    mocked_response = ApiStub::Requests::Network::ExpressRouteCircuit.create_express_route_circuit_response(@network_client)
    @circuit.stub :get, mocked_response do
      assert_equal @service.get_express_route_circuit('fog-test-rg', 'testCircuit'), mocked_response
    end
  end

  def test_get_express_route_circuit_failure
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @circuit.stub :get, response do
      assert_raises(RuntimeError) { @service.get_express_route_circuit('fog-test-rg', 'testCircuit') }
    end
  end
end
