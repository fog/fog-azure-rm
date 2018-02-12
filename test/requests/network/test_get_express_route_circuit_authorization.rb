require File.expand_path '../../test_helper', __dir__

# Test class for Get Express Route Circuit Authorization Request
class TestGetExpressRouteCircuitAuthorization < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    @network_client = @service.instance_variable_get(:@network_client)
    @circuit_authorization = @network_client.express_route_circuit_authorizations
  end

  def test_get_express_route_circuit_authorization_success
    mocked_response = ApiStub::Requests::Network::ExpressRouteCircuitAuthorization.create_express_route_circuit_authorization_response(@network_client)
    @circuit_authorization.stub :get, mocked_response do
      assert_equal @service.get_express_route_circuit_authorization('Fog-rg', 'testCircuit', 'auth-name'), mocked_response
    end
  end

  def test_get_express_route_circuit_authorization_failure
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @circuit_authorization.stub :get, response do
      assert_raises(MsRestAzure::AzureOperationError) { @service.get_express_route_circuit_authorization('Fog-rg', 'testCircuit', 'auth-name') }
    end
  end
end
