require File.expand_path '../../test_helper', __dir__

class TestApplicationGateway < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    @gateway = application_gateway(@service)
  end

  def test_model_methods
    response = ApiStub::Models::Network::ApplicationGateway.create_application_gateway_response
    methods = [
      :save,
      :destroy
    ]
    @service.stub :create_application_gateway, response do
      methods.each do |method|
        assert @gateway.respond_to? method
      end
    end
  end

  def test_model_attributes
    response = ApiStub::Models::Network::ApplicationGateway.create_application_gateway_response
    attributes = [
      :name,
      :location,
      :resource_group,
      :skuName,
      :skuTier,
      :skuCapacity,
      :gatewayIpConfigurations,
      :frontendIpConfigurations,
      :frontendPorts,
      :backendAddressPools,
      :backendHttpSettingsList,
      :httpListeners,
      :requestRoutingRules
    ]
    @service.stub :create_application_gateway, response do
      attributes.each do |attribute|
        assert @gateway.respond_to? attribute
      end
    end
  end

  def test_save_method_response
    response = ApiStub::Models::Network::ApplicationGateway.create_application_gateway_response
    @service.stub :create_application_gateway, response do
      assert_instance_of Fog::Network::AzureRM::ApplicationGateway, @gateway.save
    end
  end

  def test_destroy_method_response
    @service.stub :delete_application_gateway, true do
      assert @gateway.destroy
    end
  end
end
