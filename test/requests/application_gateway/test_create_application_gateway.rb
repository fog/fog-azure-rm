require File.expand_path '../../../test_helper', __FILE__

# Test class for Create Application Gateway Request
class TestCreateApplicationGateway < Minitest::Test
  def setup
    @service = Fog::ApplicationGateway::AzureRM.new(credentials)
    gateway_client = @service.instance_variable_get(:@network_client)
    @gateways = gateway_client.application_gateways
    @response = ApiStub::Requests::ApplicationGateway::Gateway.create_application_gateway_response(gateway_client)
  end

  def test_create_application_gateway_success
    gateway_ip_configurations = ApiStub::Requests::ApplicationGateway::Gateway.gateway_ip_configurations
    frontend_ip_configurations = ApiStub::Requests::ApplicationGateway::Gateway.frontend_ip_configurations
    frontend_ports = ApiStub::Requests::ApplicationGateway::Gateway.frontend_ports
    backend_address_pools = ApiStub::Requests::ApplicationGateway::Gateway.backend_address_pools
    backend_http_settings_list = ApiStub::Requests::ApplicationGateway::Gateway.backend_http_settings_list
    http_listeners = ApiStub::Requests::ApplicationGateway::Gateway.http_listeners
    request_routing_rules = ApiStub::Requests::ApplicationGateway::Gateway.request_routing_rules
    @gateways.stub :create_or_update, @response do
      assert_equal @service.create_application_gateway('gateway', 'East US', 'fogRM-rg', 'Standard_Medium', 'Standard', 2, gateway_ip_configurations, nil, frontend_ip_configurations, frontend_ports, nil, backend_address_pools, backend_http_settings_list, http_listeners, nil, request_routing_rules), @response
    end
  end

  def test_create_application_gateway_argument_error_failure
    @gateways.stub :create_or_update, @response do
      assert_raises ArgumentError do
        @service.create_application_gateway('gateway', 'East US', 'fogRM-rg', 'Standard_Medium', 'Standard', 2)
      end
    end
  end

  def test_create_application_gateway_exception_failure
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    gateway_ip_configurations = ApiStub::Requests::ApplicationGateway::Gateway.gateway_ip_configurations
    ssl_certificates = ApiStub::Requests::ApplicationGateway::Gateway.ssl_certificates
    frontend_ip_configurations = ApiStub::Requests::ApplicationGateway::Gateway.frontend_ip_configurations
    frontend_ports = ApiStub::Requests::ApplicationGateway::Gateway.frontend_ports
    probes = ApiStub::Requests::ApplicationGateway::Gateway.probes
    backend_address_pools = ApiStub::Requests::ApplicationGateway::Gateway.backend_address_pools
    backend_http_settings_list = ApiStub::Requests::ApplicationGateway::Gateway.backend_http_settings_list
    http_listeners = ApiStub::Requests::ApplicationGateway::Gateway.http_listeners
    url_path_paths = ApiStub::Requests::ApplicationGateway::Gateway.url_path_maps
    request_routing_rules = ApiStub::Requests::ApplicationGateway::Gateway.request_routing_rules
    @gateways.stub :create_or_update, response do
      assert_raises RuntimeError do
        @service.create_application_gateway('gateway', 'East US', 'fogRM-rg', 'Standard_Medium', 'Standard', 2, gateway_ip_configurations, ssl_certificates, frontend_ip_configurations, frontend_ports, probes, backend_address_pools, backend_http_settings_list, http_listeners, url_path_paths, request_routing_rules)
      end
    end
  end
end
