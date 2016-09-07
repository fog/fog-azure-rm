require File.expand_path '../../../test_helper', __FILE__

# Test class for Create Express Route Circuit Peering Request
class TestCreateExpressRouteCircuitPeering < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    @network_client = @service.instance_variable_get(:@network_client)
    @circuit_peerings = @network_client.express_route_circuit_peerings
  end

  def test_create_express_route_circuit_peering_success
    circuit_peering_parameters = { peering_type: 'AzurePrivatePeering' }
    mocked_response = ApiStub::Requests::Network::ExpressRouteCircuitPeering.create_express_route_circuit_peering_response(@network_client)
    @circuit_peerings.stub :create_or_update, mocked_response do
      assert_equal @service.create_or_update_express_route_circuit_peering(circuit_peering_parameters), mocked_response
    end
  end

  def test_create_express_route_circuit_argument_error_failure
    response = ApiStub::Requests::Network::ExpressRouteCircuitPeering.create_express_route_circuit_peering_response(@network_client)
    @circuit_peerings.stub :create_or_update, response do
      assert_raises ArgumentError do
        @service.create_or_update_express_route_circuit_peering('Fog-rg', 'AzurePrivatePeering', 'testCircuit', 'AzurePrivatePeering', 100, '192.168.1.0/30', '"192.168.2.0/30"', 'NotConfigured', '200', 'routing_registry_name')
      end
    end
  end

  def test_create_express_route_circuit_exception_failure
    circuit_peering_parameters = { peering_type: 'AzurePrivatePeering' }
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @circuit_peerings.stub :create_or_update, response do
      assert_raises RuntimeError do
        @service.create_or_update_express_route_circuit_peering(circuit_peering_parameters)
      end
    end
  end
end
