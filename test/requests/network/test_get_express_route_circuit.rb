require File.expand_path '../../test_helper', __dir__

# Test class for Get Express Route Circuit Request
class TestGetExpressRouteCircuit < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    client = @service.instance_variable_get(:@network_client)
    @circuit = client.express_route_circuits
    @promise = Concurrent::Promise.execute do
    end
  end

  def test_get_express_route_circuit_success
    mocked_response = ApiStub::Requests::Network::ExpressRouteCircuit.create_express_route_circuit_response
    expected_response = Azure::ARM::Network::Models::ExpressRouteCircuit.serialize_object(mocked_response.body)
    @promise.stub :value!, mocked_response do
      @circuit.stub :get, @promise do
        assert_equal @service.get_express_route_circuit('fog-test-rg', 'testCircuit'), expected_response
      end
    end
  end

  def test_get_express_route_circuit_failure
    response = -> { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @promise.stub :value!, response do
      @circuit.stub :get, @promise do
        assert_raises(RuntimeError) { @service.get_express_route_circuit('fog-test-rg', 'testCircuit') }
      end
    end
  end
end
