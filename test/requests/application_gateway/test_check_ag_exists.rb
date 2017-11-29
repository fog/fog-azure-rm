require File.expand_path '../../test_helper', __dir__

# Test class for Check Application Gateway Exists Request
class TestCheckAGExists < Minitest::Test
  def setup
    @service = Fog::ApplicationGateway::AzureRM.new(credentials)
    @gateway_client = @service.instance_variable_get(:@network_client)
    @gateways = @gateway_client.application_gateways
  end

  def test_check_ag_exists_success
    mocked_response = ApiStub::Requests::ApplicationGateway::Gateway.create_application_gateway_response(@gateway_client)
    @gateways.stub :get, mocked_response do
      assert @service.check_ag_exists('fog-test-rg', 'fogRM-rg')
    end
  end

  def test_check_ag_exists_failure
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, get_mock_response, 'error' => { 'message' => 'mocked exception', 'code' => 'ResourceNotFound' }) }
    @gateways.stub :get, response do
      assert !@service.check_ag_exists('fog-test-rg', 'fogRM-rg')
    end
  end

  def test_check_ag_exists_exception
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, get_mock_response, 'error' => { 'message' => 'mocked exception', 'code' => 'ResourceGroupNotFound' }) }
    @gateways.stub :get, response do
      assert !@service.check_ag_exists('fog-test-rg', 'fogRM-rg')
    end
  end
end
