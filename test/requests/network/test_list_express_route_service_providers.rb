require File.expand_path '../../../test_helper', __FILE__

# Test class for List Express Service Providers Request
class TestListExpressServiceProviders < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    @network_client = @service.instance_variable_get(:@network_client)
    @service_provider = @network_client.express_route_service_providers
  end

  def test_list_express_route_service_providers_success
    mocked_response = ApiStub::Requests::Network::ExpressRouteServiceProvider.list_express_route_service_providers_response(@network_client)
    @service_provider.stub :list, mocked_response do
      assert_equal @service.list_express_route_service_providers, mocked_response
    end
  end

  def test_list_express_route_service_providers_failure
    response = -> { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @service_provider.stub :list, response do
      assert_raises(RuntimeError) { @service.list_express_route_service_providers }
    end
  end
end
