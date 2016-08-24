require File.expand_path '../../test_helper', __dir__

# Test class for List Express Route Circuits Request
class TestListExpressRouteCircuits < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    client = @service.instance_variable_get(:@network_client)
    @circuit = client.express_route_circuits
    @promise = Concurrent::Promise.execute do
    end
  end

  def test_list_express_route_circuits_success
    mocked_response = ApiStub::Requests::Network::ExpressRouteCircuit.list_express_route_circuit_response
    expected_response = Azure::ARM::Network::Models::ExpressRouteCircuitListResult.serialize_object(mocked_response.body)
    @promise.stub :value!, mocked_response do
      @circuit.stub :list, @promise do
        assert_equal @service.list_express_route_circuits('fogRM-rg'), expected_response['value']
      end
    end
  end

  def test_list_express_route_circuits_failure
    response = -> { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @promise.stub :value!, response do
      @circuit.stub :list, @promise do
        assert_raises(RuntimeError) { @service.list_express_route_circuits('fogRM-rg') }
      end
    end
  end
end
