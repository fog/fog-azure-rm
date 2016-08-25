require File.expand_path '../../test_helper', __dir__

# Test class for Create Express Route Circuit Peering Request
class TestCreateExpressRouteCircuitPeering < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    client = @service.instance_variable_get(:@network_client)
    @circuit_peerings = client.express_route_circuit_peerings
    @promise = Concurrent::Promise.execute do
    end
  end

  def test_create_express_route_circuit_peering_success
    circuit_peering_parameters = { peering_type: 'AzurePrivatePeering' }
    mocked_response = ApiStub::Requests::Network::ExpressRouteCircuitPeering.create_express_route_circuit_peering_response
    expected_response = Azure::ARM::Network::Models::ExpressRouteCircuitPeering.serialize_object(mocked_response.body)
    @promise.stub :value!, mocked_response do
      @circuit_peerings.stub :create_or_update, @promise do
        assert_equal @service.create_or_update_express_route_circuit_peering(circuit_peering_parameters), expected_response
      end
    end
  end

  def test_create_express_route_circuit_argument_error_failure
    response = ApiStub::Requests::Network::ExpressRouteCircuitPeering.create_express_route_circuit_peering_response
    @promise.stub :value!, response do
      @circuit_peerings.stub :create_or_update, @promise do
        assert_raises ArgumentError do
          @service.create_or_update_express_route_circuit_peering('Fog-rg', 'AzurePrivatePeering', 'testCircuit', 'AzurePrivatePeering', 100, '192.168.1.0/30', '"192.168.2.0/30"', 'NotConfigured', '200', 'routing_registry_name')
        end
      end
    end
  end

  def test_create_express_route_circuit_exception_failure
    circuit_peering_parameters = { peering_type: 'AzurePrivatePeering' }
    response = -> { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @promise.stub :value!, response do
      @circuit_peerings.stub :create_or_update, @promise do
        assert_raises RuntimeError do
          @service.create_or_update_express_route_circuit_peering(circuit_peering_parameters)
        end
      end
    end
  end
end
