require File.expand_path '../../test_helper', __dir__

# Test class for Create Local Network Gateway Request
class TestCreateLocalNetworkGateway < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    @network_client = @service.instance_variable_get(:@network_client)
    @local_network_gateways = @network_client.local_network_gateways
  end

  def test_create_local_network_gateway_success
    network_gateway_parms = {}
    mocked_response = ApiStub::Requests::Network::LocalNetworkGateway.create_local_network_gateway_response
    @local_network_gateways.stub :create_or_update, mocked_response do
      assert_equal @service.create_or_update_local_network_gateway(network_gateway_parms), mocked_response
    end
  end

  def test_create_local_network_gateway_argument_error_failure
    response = ApiStub::Requests::Network::LocalNetworkGateway.create_local_network_gateway_response
    @local_network_gateways.stub :create_or_update, response do
      assert_raises ArgumentError do
        @service.create_or_update_local_network_gateway
      end
    end
  end

  def test_create_local_network_gateway_exception_failure
    local_network_gateway_parms = {}
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @local_network_gateways.stub :create_or_update, response do
      assert_raises RuntimeError do
        @service.create_or_update_local_network_gateway(local_network_gateway_parms)
      end
    end
  end
end
