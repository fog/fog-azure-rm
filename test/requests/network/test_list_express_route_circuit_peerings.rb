require File.expand_path '../../test_helper', __dir__

# Test class for List Express Route Circuit Peeringss Request
class TestListExpressRouteCircuitPeerings < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    client = @service.instance_variable_get(:@network_client)
    @circuit_peering = client.express_route_circuit_peerings
    @promise = Concurrent::Promise.execute do
    end
  end

  def test_list_express_route_circuit_peerings_success
    mocked_response = ApiStub::Requests::Network::ExpressRouteCircuitPeering.list_express_route_circuit_peering_response
    expected_response = Azure::ARM::Network::Models::ExpressRouteCircuitPeeringListResult.serialize_object(mocked_response.body)
    @promise.stub :value!, mocked_response do
      @circuit_peering.stub :list, @promise do
        assert_equal @service.list_express_route_circuit_peerings('fogRM-rg', 'testCircuit'), expected_response['value']
      end
    end
  end

  def test_list_express_route_circuit_peerings_failure
    response = -> { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @promise.stub :value!, response do
      @circuit_peering.stub :list, @promise do
        assert_raises(RuntimeError) { @service.list_express_route_circuit_peerings('fogRM-rg', 'testCircuit') }
      end
    end
  end
end
