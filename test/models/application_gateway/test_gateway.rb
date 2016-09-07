require File.expand_path '../../../test_helper', __FILE__

# Test class for ApplicationGateway Model
class TestGateway < Minitest::Test
  def setup
    @service = Fog::ApplicationGateway::AzureRM.new(credentials)
    @gateway = gateway(@service)
    @gateway_client = @service.instance_variable_get(:@network_client)
    @response = ApiStub::Models::ApplicationGateway::Gateway.create_application_gateway_response(@gateway_client)
  end

  def test_model_methods
    methods = [
      :save,
      :destroy
    ]
    methods.each do |method|
      assert @gateway.respond_to? method
    end
  end

  def test_model_attributes
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
    attributes.each do |attribute|
      assert @gateway.respond_to? attribute
    end
  end

  def test_save_method_response
    @service.stub :create_application_gateway, @response do
      assert_instance_of Fog::ApplicationGateway::AzureRM::Gateway, @gateway.save
    end
  end

  def test_destroy_method_response
    @service.stub :delete_application_gateway, true do
      assert @gateway.destroy
    end
  end
end
