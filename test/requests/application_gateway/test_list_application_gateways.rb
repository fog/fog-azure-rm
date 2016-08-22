require File.expand_path '../../test_helper', __dir__

# Test class for List Application Gateway Request
class TestListApplicationGateways < Minitest::Test
  def setup
    @service = Fog::ApplicationGateway::AzureRM.new(credentials)
    client = @service.instance_variable_get(:@network_client)
    @gateways = client.application_gateways
    @promise = Concurrent::Promise.execute do
    end
  end

  def test_list_application_gateways_success
    mocked_response = ApiStub::Requests::ApplicationGateway::Gateway.list_application_gateway_response
    expected_response = Azure::ARM::Network::Models::ApplicationGatewayListResult.serialize_object(mocked_response.body)
    @promise.stub :value!, mocked_response do
      @gateways.stub :list, @promise do
        assert_equal @service.list_application_gateways('fogRM-rg'), expected_response['value']
      end
    end
  end

  def test_list_application_gateways_failure
    response = -> { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @promise.stub :value!, response do
      @gateways.stub :list, @promise do
        assert_raises(RuntimeError) { @service.list_application_gateways('fogRM-rg') }
      end
    end
  end
end
