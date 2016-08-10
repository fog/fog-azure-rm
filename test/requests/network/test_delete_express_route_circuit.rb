require File.expand_path '../../test_helper', __dir__

# Test class for Delete Express Route Circuit Request
class TestDeleteExpressRouteCircuit < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    client = @service.instance_variable_get(:@network_client)
    @circuit = client.express_route_circuits
    @promise = Concurrent::Promise.execute do
    end
  end

  def test_delete_express_route_circuit_success
    response = true
    @promise.stub :value!, response do
      @circuit.stub :delete, @promise do
        assert @service.delete_express_route_circuit('fogRM-rg', 'testCircuit'), response
      end
    end
  end

  def test_delete_express_route_circuit_failure
    response = -> { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @promise.stub :value!, response do
      @circuit.stub :delete, @promise do
        assert_raises(RuntimeError) { @service.delete_express_route_circuit('fogRM-rg', 'testCircuit') }
      end
    end
  end
end
