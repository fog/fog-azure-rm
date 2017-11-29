require File.expand_path '../../test_helper', __dir__

# Test class for Check Express Route Circuit Exists Request
class TestCheckExpressRouteCircuitExists < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    @network_client = @service.instance_variable_get(:@network_client)
    @circuit = @network_client.express_route_circuits
  end

  def test_check_express_route_circuit_exists_success
    mocked_response = ApiStub::Requests::Network::ExpressRouteCircuit.create_express_route_circuit_response(@network_client)
    @circuit.stub :get, mocked_response do
      assert @service.check_express_route_circuit_exists('fog-test-rg', 'testCircuit')
    end
  end

  def test_check_express_route_circuit_exists_failure
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, get_mock_response, 'error' => { 'message' => 'mocked exception', 'code' => 'ResourceNotFound' }) }
    @circuit.stub :get, response do
      assert !@service.check_express_route_circuit_exists('fog-test-rg', 'testCircuit')
    end
  end

  def test_check_express_route_circuit_exists_exception
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, get_mock_response, 'error' => { 'message' => 'mocked exception', 'code' => 'ResourceGroupNotFound' }) }
    @circuit.stub :get, response do
      assert !@service.check_express_route_circuit_exists('fog-test-rg', 'testCircuit')
    end
  end
end
