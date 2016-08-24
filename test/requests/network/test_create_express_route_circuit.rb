require File.expand_path '../../test_helper', __dir__

# Test class for Create Express Route Circuit Request
class TestCreateExpressRouteCircuit < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    client = @service.instance_variable_get(:@network_client)
    @circuit = client.express_route_circuits
    @promise = Concurrent::Promise.execute do
    end
  end

  def test_create_express_route_circuit_success
    mocked_response = ApiStub::Requests::Network::ExpressRouteCircuit.create_express_route_circuit_response
    expected_response = Azure::ARM::Network::Models::ExpressRouteCircuit.serialize_object(mocked_response.body)
    @promise.stub :value!, mocked_response do
      peerings = ApiStub::Requests::Network::ExpressRouteCircuit.peerings
      express_route_circuit_parameters = { peerings: peerings }
      @circuit.stub :create_or_update, @promise do
        assert_equal @service.create_or_update_express_route_circuit(express_route_circuit_parameters), expected_response
      end
    end
  end

  def test_create_express_route_circuit_argument_error_failure
    response = ApiStub::Requests::Network::ExpressRouteCircuit.create_express_route_circuit_response
    @promise.stub :value!, response do
      @circuit.stub :create_or_update, @promise do
        assert_raises ArgumentError do
          @service.create_or_update_express_route_circuit('Fog-rg', 'testCircuit', 'eastus', 'value1', 'value2', 'Standard_MeteredData', 'Standard', 'MeteredData', 'Telenor', 'London', 100)
        end
      end
    end
  end

  def test_create_express_route_circuit_exception_failure
    response = -> { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @promise.stub :value!, response do
      peerings = ApiStub::Requests::Network::ExpressRouteCircuit.peerings
      express_route_circuit_parameters = { peerings: peerings }
      @circuit.stub :create_or_update, @promise do
        assert_raises RuntimeError do
          @service.create_or_update_express_route_circuit(express_route_circuit_parameters)
        end
      end
    end
  end
end
