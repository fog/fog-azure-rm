require File.expand_path '../../test_helper', __dir__

# Test class for Create Application Gateway Request
class TestCreateOrUpdateApplicationGateway < Minitest::Test
  def setup
    @service = Fog::ApplicationGateway::AzureRM.new(credentials)
    gateway_client = @service.instance_variable_get(:@network_client)
    @gateways = gateway_client.application_gateways
    @response = ApiStub::Requests::ApplicationGateway::Gateway.create_application_gateway_response(gateway_client)
    @gateway_params = ApiStub::Requests::ApplicationGateway::Gateway.gateway_params
  end

  def test_create_or_update_application_gateway_success
    @gateways.stub :create_or_update, @response do
      assert_equal @service.create_or_update_application_gateway(@gateway_params), @response
    end
  end

  def test_create_or_update_application_gateway_argument_error_failure
    @gateways.stub :create_or_update, @response do
      assert_raises ArgumentError do
        @service.create_or_update_application_gateway('gateway', 'East US', 'fogRM-rg', 'Standard_Medium', 'Standard', 2)
      end
    end
  end

  def test_create_or_update_application_gateway_exception_failure
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @gateways.stub :create_or_update, response do
      assert_raises MsRestAzure::AzureOperationError do
        @service.create_or_update_application_gateway(@gateway_params)
      end
    end
  end
end
