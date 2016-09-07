require File.expand_path '../../../test_helper', __FILE__

# Test class for List Application Gateway Request
class TestListApplicationGateways < Minitest::Test
  def setup
    @service = Fog::ApplicationGateway::AzureRM.new(credentials)
    @gateway_client = @service.instance_variable_get(:@network_client)
    @gateways = @gateway_client.application_gateways
  end

  def test_list_application_gateways_success
    mocked_response = ApiStub::Requests::ApplicationGateway::Gateway.list_application_gateway_response(@gateway_client)
    @gateways.stub :list_as_lazy, mocked_response do
      assert_equal @service.list_application_gateways('fogRM-rg'), mocked_response.value
    end
  end

  def test_list_application_gateways_failure
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @gateways.stub :list_as_lazy, response do
      assert_raises(RuntimeError) { @service.list_application_gateways('fogRM-rg') }
    end
  end
end
