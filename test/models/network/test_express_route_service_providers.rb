require File.expand_path '../../../test_helper', __FILE__

# Test class for ExpressRouteServiceProvider Collection
class TestExpressRouteServiceProviders < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    @service_providers = Fog::Network::AzureRM::ExpressRouteServiceProviders.new(service: @service)
    @network_client = @service.instance_variable_get(:@network_client)
  end

  def test_collection_methods
    methods = [
      :all
    ]
    methods.each do |method|
      assert @service_providers.respond_to? method
    end
  end

  def test_all_method_response
    response = ApiStub::Models::Network::ExpressRouteServiceProvider.list_express_route_service_provider_response(@network_client)
    @service.stub :list_express_route_service_providers, response do
      assert_instance_of Fog::Network::AzureRM::ExpressRouteServiceProviders, @service_providers.all
      assert @service_providers.all.size >= 1
      @service_providers.all.each do |service_provider|
        assert_instance_of Fog::Network::AzureRM::ExpressRouteServiceProvider, service_provider
      end
    end
  end
end
