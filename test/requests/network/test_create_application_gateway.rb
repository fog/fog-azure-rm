require File.expand_path '../../test_helper', __dir__

# Test class for Create Application Gateway Request
class TestCreateApplicationGateway < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    client = @service.instance_variable_get(:@network_client)
    @gateways = client.application_gateways
    @promise = Concurrent::Promise.execute do
    end
  end

  def test_create_application_gateway_success
    mocked_response = ApiStub::Requests::Network::ApplicationGateway.create_application_gateway_response
    expected_response = Azure::ARM::Network::Models::ApplicationGateway.serialize_object(mocked_response.body)
    @promise.stub :value!, mocked_response do
      gateway_ip_configurations = ApiStub::Requests::Network::ApplicationGateway.gateway_ip_configurations
      frontend_ip_configurations = ApiStub::Requests::Network::ApplicationGateway.frontend_ip_configurations
      frontend_ports = ApiStub::Requests::Network::ApplicationGateway.frontend_ports
      backend_address_pools = ApiStub::Requests::Network::ApplicationGateway.backend_address_pools
      backend_http_settings_list = ApiStub::Requests::Network::ApplicationGateway.backend_http_settings_list
      http_listeners = ApiStub::Requests::Network::ApplicationGateway.http_listeners
      request_routing_rules = ApiStub::Requests::Network::ApplicationGateway.request_routing_rules
      @gateways.stub :create_or_update, @promise do
        assert_equal @service.create_application_gateway('gateway', 'East US', 'fogRM-rg', 'Standard_Medium', 'Standard', 2, gateway_ip_configurations, nil, frontend_ip_configurations, frontend_ports, nil, backend_address_pools, backend_http_settings_list, http_listeners, nil, request_routing_rules), expected_response
      end
    end
  end

  def test_create_application_gateway_argument_error_failure
    response = ApiStub::Requests::Network::ApplicationGateway.create_application_gateway_response
    @promise.stub :value!, response do
      @gateways.stub :create_or_update, @promise do
        assert_raises ArgumentError do
          @service.create_application_gateway('gateway', 'East US', 'fogRM-rg', 'Standard_Medium', 'Standard', 2)
        end
      end
    end
  end

  def test_create_application_gateway_exception_failure
    response = -> { fail MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @promise.stub :value!, response do
      gateway_ip_configurations = ApiStub::Requests::Network::ApplicationGateway.gateway_ip_configurations
      ssl_certificates = ApiStub::Requests::Network::ApplicationGateway.ssl_certificates
      frontend_ip_configurations = ApiStub::Requests::Network::ApplicationGateway.frontend_ip_configurations
      frontend_ports = ApiStub::Requests::Network::ApplicationGateway.frontend_ports
      probes = ApiStub::Requests::Network::ApplicationGateway.probes
      backend_address_pools = ApiStub::Requests::Network::ApplicationGateway.backend_address_pools
      backend_http_settings_list = ApiStub::Requests::Network::ApplicationGateway.backend_http_settings_list
      http_listeners = ApiStub::Requests::Network::ApplicationGateway.http_listeners
      url_path_paths = ApiStub::Requests::Network::ApplicationGateway.url_path_maps
      request_routing_rules = ApiStub::Requests::Network::ApplicationGateway.request_routing_rules
      @gateways.stub :create_or_update, @promise do
        assert_raises RuntimeError do
          @service.create_application_gateway('gateway', 'East US', 'fogRM-rg', 'Standard_Medium', 'Standard', 2, gateway_ip_configurations, ssl_certificates, frontend_ip_configurations, frontend_ports, probes, backend_address_pools, backend_http_settings_list, http_listeners, url_path_paths, request_routing_rules)
        end
      end
    end
  end
end
