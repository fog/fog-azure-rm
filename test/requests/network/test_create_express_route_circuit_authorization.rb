require File.expand_path '../../test_helper', __dir__

# Test class for Create Express Route Circuit Authorization Request
class TestCreateExpressRouteCircuitAuthorization < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    @network_client = @service.instance_variable_get(:@network_client)
    @circuit_authorizations = @network_client.express_route_circuit_authorizations
    @auth_params = ApiStub::Requests::Network::ExpressRouteCircuitAuthorization.auth_hash
    @mocked_response = ApiStub::Requests::Network::ExpressRouteCircuitAuthorization.create_express_route_circuit_authorization_response(@network_client)
  end

  def test_create_express_route_circuit_authorization_success
    @circuit_authorizations.stub :create_or_update, @mocked_response do
      assert_equal @service.create_or_update_express_route_circuit_authorization(@auth_params), @mocked_response
    end
  end

  def test_create_express_route_circuit_authorization_argument_error_failure
    @circuit_authorizations.stub :create_or_update, @mocked_response do
      assert_raises ArgumentError do
        @service.create_or_update_express_route_circuit_authorization('test-resource-group', 'circuit-name')
      end
    end
  end

  def test_create_express_route_circuit_authorization_exception_failure
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @circuit_authorizations.stub :create_or_update, response do
      assert_raises RuntimeError do
        @service.create_or_update_express_route_circuit_authorization(@auth_params)
      end
    end
  end
end
