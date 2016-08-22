require File.expand_path '../../test_helper', __dir__

# Test class for ApplicationGateway Model
class TestGateway < Minitest::Test
  def setup
    @service = Fog::ApplicationGateway::AzureRM.new(credentials)
    @gateway = gateway(@service)
  end

  def test_model_methods
    response = ApiStub::Models::ApplicationGateway::Gateway.create_application_gateway_response
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
    response = ApiStub::Models::ApplicationGateway::Gateway.create_application_gateway_response
    attributes = [
      :name,
      :location,
      :resource_group,
      :sku_name,
      :sku_tier,
      :sku_capacity,
      :gateway_ip_configurations,
      :ssl_certificates,
      :frontend_ip_configurations,
      :frontend_ports,
      :probes,
      :backend_address_pools,
      :backend_http_settings_list,
      :http_listeners,
      :url_path_maps,
      :request_routing_rules
    ]
    @service.stub :create_application_gateway, response do
      attributes.each do |attribute|
        assert @gateway.respond_to? attribute
      end
    end
  end

  def test_save_method_response
    response = ApiStub::Models::ApplicationGateway::Gateway.create_application_gateway_response
    @service.stub :create_application_gateway, response do
      assert_instance_of Fog::ApplicationGateway::AzureRM::Gateway, @gateway.save
    end
  end

  def test_destroy_method_response
    @service.stub :delete_application_gateway, true do
      assert @gateway.destroy
    end
  end
end
