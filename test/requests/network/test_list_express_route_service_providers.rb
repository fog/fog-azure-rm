require File.expand_path '../../test_helper', __dir__

# Test class for List Express Service Providers Request
class TestListExpressServiceProviders < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    client = @service.instance_variable_get(:@network_client)
    @service_provider = client.express_route_service_providers
    @promise = Concurrent::Promise.execute do
    end
  end

  def test_list_express_route_service_providers_success
    mocked_response = ApiStub::Requests::Network::ExpressRouteServiceProvider.list_express_route_service_providers_response
    expected_response = Azure::ARM::Network::Models::ExpressRouteServiceProviderListResult.serialize_object(mocked_response.body)
    @promise.stub :value!, mocked_response do
      @service_provider.stub :list, @promise do
        assert_equal @service.list_express_route_service_providers, expected_response['value']
      end
    end
  end

  def test_list_express_route_service_providers_failure
    response = -> { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @promise.stub :value!, response do
      @service_provider.stub :list, @promise do
        assert_raises(RuntimeError) { @service.list_express_route_service_providers }
      end
    end
  end
end
