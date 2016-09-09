require File.expand_path '../../test_helper', __dir__

# Test class for ApplicationGateway Model
class TestGateway < Minitest::Test
  def setup
    @service = Fog::ApplicationGateway::AzureRM.new(credentials)
    @gateway = gateway(@service)
    @gateway_client = @service.instance_variable_get(:@network_client)
    @response = ApiStub::Models::ApplicationGateway::Gateway.create_application_gateway_response(@gateway_client)
    gateways = Fog::ApplicationGateway::AzureRM::Gateways.new(resource_group: 'fog-test-rg', service: @service)
    @service.stub :get_application_gateway, @response do
      @gateway_obj = gateways.get('fog-test-rg', 'gateway')
    end
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
    @service.stub :create_or_update_application_gateway, @response do
      assert_instance_of Fog::ApplicationGateway::AzureRM::Gateway, @gateway.save
    end
  end

  def test_update_sku
    @service.stub :update_sku_attributes, @response do
      assert_instance_of Fog::ApplicationGateway::AzureRM::Gateway, @gateway_obj.update_sku('Standard_Medium','2')
    end
  end

  def test_update_gateway_ip_configuration
    @service.stub :update_subnet_id_in_gateway_ip_configuration, @response do
      assert_instance_of Fog::ApplicationGateway::AzureRM::Gateway, @gateway_obj.update_gateway_ip_configuration('/subscriptions/{guid}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworks/vnet/subnets/GatewaySubnet')
    end
  end

  def test_add_ssl_certificate
    ssl_certifcate = ApiStub::Models::ApplicationGateway::Gateway.ssl_certifcate
    @service.stub :create_or_update_application_gateway, @response do
      assert_instance_of Fog::ApplicationGateway::AzureRM::Gateway, @gateway_obj.add_ssl_certificate(ssl_certifcate)
    end
  end

  def test_remove_ssl_certificate
    ssl_certifcate = ApiStub::Models::ApplicationGateway::Gateway.ssl_certifcate
    @service.stub :create_or_update_application_gateway, @response do
      assert_instance_of Fog::ApplicationGateway::AzureRM::Gateway, @gateway_obj.remove_ssl_certificate(ssl_certifcate)
    end
  end

  def test_add_frontend_port
    frontend_port = ApiStub::Models::ApplicationGateway::Gateway.frontend_port
    @service.stub :create_or_update_application_gateway, @response do
      assert_instance_of Fog::ApplicationGateway::AzureRM::Gateway, @gateway_obj.add_frontend_port(frontend_port)
    end
  end

  def test_remove_frontend_port
    frontend_port = ApiStub::Models::ApplicationGateway::Gateway.frontend_port
    @service.stub :create_or_update_application_gateway, @response do
      assert_instance_of Fog::ApplicationGateway::AzureRM::Gateway, @gateway_obj.remove_frontend_port(frontend_port)
    end
  end

  def test_add_probe
    probe = ApiStub::Models::ApplicationGateway::Gateway.probe
    @service.stub :create_or_update_application_gateway, @response do
      assert_instance_of Fog::ApplicationGateway::AzureRM::Gateway, @gateway_obj.add_probe(probe)
    end
  end

  def test_remove_probe
    probe = ApiStub::Models::ApplicationGateway::Gateway.probe
    @service.stub :create_or_update_application_gateway, @response do
      assert_instance_of Fog::ApplicationGateway::AzureRM::Gateway, @gateway_obj.remove_probe(probe)
    end
  end

  def test_destroy_method_response
    @service.stub :delete_application_gateway, true do
      assert @gateway.destroy
    end
  end
end
