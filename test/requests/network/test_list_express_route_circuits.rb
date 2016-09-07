require File.expand_path '../../../test_helper', __FILE__

# Test class for List Express Route Circuits Request
class TestListExpressRouteCircuits < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    @network_client = @service.instance_variable_get(:@network_client)
    @circuit = @network_client.express_route_circuits
    @promise = Concurrent::Promise.execute do
    end
  end

  def test_list_express_route_circuits_success
    mocked_response = ApiStub::Requests::Network::ExpressRouteCircuit.list_express_route_circuit_response(@network_client)
    @circuit.stub :list, mocked_response do
      assert_equal @service.list_express_route_circuits('fogRM-rg'), mocked_response
    end
  end

  def test_list_express_route_circuits_failure
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @circuit.stub :list, response do
      assert_raises(RuntimeError) { @service.list_express_route_circuits('fogRM-rg') }
    end
  end
end
