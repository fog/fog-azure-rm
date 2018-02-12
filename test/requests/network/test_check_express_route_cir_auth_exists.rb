require File.expand_path '../../test_helper', __dir__

# Test class for Check Express Route Circuit Authorization Exists Request
class TestCheckExpressRouteCirAuthExists < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    @network_client = @service.instance_variable_get(:@network_client)
    @circuit_authorization = @network_client.express_route_circuit_authorizations
  end

  def test_check_express_route_cir_auth_exists_success
    mocked_response = ApiStub::Requests::Network::ExpressRouteCircuitAuthorization.create_express_route_circuit_authorization_response(@network_client)
    @circuit_authorization.stub :get, mocked_response do
      assert @service.check_express_route_cir_auth_exists('Fog-rg', 'testCircuit', 'auth-name')
    end
  end

  def test_check_express_route_cir_auth_exists_failure
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, create_mock_response, 'error' => { 'message' => 'mocked exception', 'code' => 'NotFound' }) }
    @circuit_authorization.stub :get, response do
      assert !@service.check_express_route_cir_auth_exists('Fog-rg', 'testCircuit', 'auth-name')
    end
  end

  def test_check_express_route_cir_auth_resource_group_exists_failure
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, create_mock_response, 'error' => { 'message' => 'mocked exception', 'code' => 'ResourceGroupNotFound' }) }
    @circuit_authorization.stub :get, response do
      assert !@service.check_express_route_cir_auth_exists('Fog-rg', 'testCircuit', 'auth-name')
    end
  end

  def test_check_express_route_cir_auth_exists_exception
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, create_mock_response, 'error' => { 'message' => 'mocked exception', 'code' => 'Exception' }) }
    @circuit_authorization.stub :get, response do
      assert_raises(MsRestAzure::AzureOperationError) { @service.check_express_route_cir_auth_exists('Fog-rg', 'testCircuit', 'auth-name') }
    end
  end
end
