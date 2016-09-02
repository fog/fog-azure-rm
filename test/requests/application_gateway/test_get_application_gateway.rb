require File.expand_path '../../test_helper', __dir__

# Test class for Get Application Gateway Request
class TestGetApplicationGateway < Minitest::Test
  def setup
    @service = Fog::ApplicationGateway::AzureRM.new(credentials)
    @gateway_client = @service.instance_variable_get(:@network_client)
    @gateways = @gateway_client.application_gateways
  end

  def test_get_application_gateway_success
    mocked_response = ApiStub::Requests::ApplicationGateway::Gateway.create_application_gateway_response(@gateway_client)
    @gateways.stub :get, mocked_response do
      assert_equal @service.get_application_gateway('fog-test-rg', 'fogRM-rg'), mocked_response
    end
  end

  def test_get_application_gateway_failure
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @gateways.stub :get, response do
      assert_raises(RuntimeError) { @service.get_application_gateway('fog-test-rg', 'fogRM-rg') }
    end
  end
end
