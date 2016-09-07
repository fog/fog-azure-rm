require File.expand_path '../../test_helper', __dir__

# Test class for List Express Route Circuit Authorization Request
class TestListExpressRouteCircuitAuthorization < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    @network_client = @service.instance_variable_get(:@network_client)
    @circuit_authorization = @network_client.express_route_circuit_authorizations
  end

  def test_list_express_route_circuit_authorizations_success
    mocked_response = [ApiStub::Requests::Network::ExpressRouteCircuitAuthorization.create_express_route_circuit_authorization_response(@network_client)]
    @circuit_authorization.stub :list, mocked_response do
      assert_equal @service.list_express_route_circuit_authorizations('fogRM-rg', 'testCircuit'), mocked_response
    end
  end

  def test_list_express_route_circuit_authorizations_failure
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @circuit_authorization.stub :list, response do
      assert_raises(RuntimeError) { @service.list_express_route_circuit_authorizations('fogRM-rg', 'testCircuit') }
    end
  end
end
