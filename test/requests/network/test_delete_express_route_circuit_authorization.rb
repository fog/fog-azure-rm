require File.expand_path '../../test_helper', __dir__

# Test class for Delete Express Route Circuit Authorization Request
class TestDeleteExpressRouteCircuitAuthorization < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    @network_client = @service.instance_variable_get(:@network_client)
    @circuit_authorization = @network_client.express_route_circuit_authorizations
  end

  def test_delete_express_route_circuit_authorization_success
    @circuit_authorization.stub :delete, true do
      assert @service.delete_express_route_circuit_authorization('Fog-rg', 'testCircuit', 'auth-name'), true
    end
  end

  def test_delete_express_route_circuit_authorization_failure
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @circuit_authorization.stub :delete, response do
      assert_raises(MsRestAzure::AzureOperationError) { @service.delete_express_route_circuit_authorization('Fog-rg', 'testCircuit', 'auth-name') }
    end
  end
end
