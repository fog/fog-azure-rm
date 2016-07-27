require File.expand_path '../../test_helper', __dir__

# Test class for ApplicationGateway Collection
class TestApplicationGateways < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    @gateways = Fog::Network::AzureRM::ApplicationGateways.new(resource_group: 'fog-test-rg', service: @service)
  end

  def test_collection_methods
    methods = [
      :all,
      :get
    ]
    methods.each do |method|
      assert @gateways.respond_to? method
    end
  end

  def test_collection_attributes
    assert @gateways.respond_to? :resource_group
  end

  def test_all_method_response
    response = [ApiStub::Models::Network::ApplicationGateway.create_application_gateway_response]
    @service.stub :list_application_gateways, response do
      assert_instance_of Fog::Network::AzureRM::ApplicationGateways, @gateways.all
      assert @gateways.all.size >= 1
      @gateways.all.each do |application_gateway|
        assert_instance_of Fog::Network::AzureRM::ApplicationGateway, application_gateway
      end
    end
  end

  def test_get_method_response
    response = [ApiStub::Models::Network::ApplicationGateway.create_application_gateway_response]
    @service.stub :list_application_gateways, response do
      assert_instance_of Fog::Network::AzureRM::ApplicationGateway, @gateways.get('gateway')
      assert @gateways.get('wrong-name').nil?, true
    end
  end
end
