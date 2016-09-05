require File.expand_path '../../test_helper', __dir__

# Test class for Create Express Route Circuit Request
class TestCreateExpressRouteCircuit < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    @network_client = @service.instance_variable_get(:@network_client)
    @circuit = @network_client.express_route_circuits
  end

  def test_create_express_route_circuit_success
    mocked_response = ApiStub::Requests::Network::ExpressRouteCircuit.create_express_route_circuit_response(@network_client)
    peerings = ApiStub::Requests::Network::ExpressRouteCircuit.peerings
    express_route_circuit_parameters = { peerings: peerings }
    @circuit.stub :create_or_update, mocked_response do
      assert_equal @service.create_or_update_express_route_circuit(express_route_circuit_parameters), mocked_response
    end
  end

  def test_create_express_route_circuit_argument_error_failure
    response = ApiStub::Requests::Network::ExpressRouteCircuit.create_express_route_circuit_response(@network_client)
    @circuit.stub :create_or_update, response do
      assert_raises ArgumentError do
        @service.create_or_update_express_route_circuit('Fog-rg', 'testCircuit', 'eastus', 'value1', 'value2', 'Standard_MeteredData', 'Standard', 'MeteredData', 'Telenor', 'London', 100)
      end
    end
  end

  def test_create_express_route_circuit_exception_failure
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    peerings = ApiStub::Requests::Network::ExpressRouteCircuit.peerings
    express_route_circuit_parameters = { peerings: peerings }
    @circuit.stub :create_or_update, response do
      assert_raises RuntimeError do
        @service.create_or_update_express_route_circuit(express_route_circuit_parameters)
      end
    end
  end
end
