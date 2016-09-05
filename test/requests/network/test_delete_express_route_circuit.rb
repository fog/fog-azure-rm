require File.expand_path '../../test_helper', __dir__

# Test class for Delete Express Route Circuit Request
class TestDeleteExpressRouteCircuit < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    @network_client = @service.instance_variable_get(:@network_client)
    @circuit = @network_client.express_route_circuits
  end

  def test_delete_express_route_circuit_success
    response = true
    @circuit.stub :delete, response do
      assert @service.delete_express_route_circuit('fogRM-rg', 'testCircuit'), response
    end
  end

  def test_delete_express_route_circuit_failure
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @circuit.stub :delete, response do
      assert_raises(RuntimeError) { @service.delete_express_route_circuit('fogRM-rg', 'testCircuit') }
    end
  end
end
