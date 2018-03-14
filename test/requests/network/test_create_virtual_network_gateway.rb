require File.expand_path '../../test_helper', __dir__

# Test class for Create Virtual Network Gateway Request
class TestCreateVirtualNetworkGateway < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    @network_client = @service.instance_variable_get(:@network_client)
    @network_gateways = @network_client.virtual_network_gateways
  end

  def test_create_virtual_network_gateway_success
    network_gateway_parms = {}
    mocked_response = ApiStub::Requests::Network::VirtualNetworkGateway.create_virtual_network_gateway_response(@network_client)
    @network_gateways.stub :create_or_update, mocked_response do
      assert_equal @service.create_or_update_virtual_network_gateway(network_gateway_parms), mocked_response
    end
  end

  def test_create_virtual_network_gateway_argument_error_failure
    response = ApiStub::Requests::Network::VirtualNetworkGateway.create_virtual_network_gateway_response(@network_client)
    @network_gateways.stub :create_or_update, response do
      assert_raises ArgumentError do
        @service.create_or_update_virtual_network_gateway
      end
    end
  end

  def test_create_virtual_network_gateway_exception_failure
    network_gateway_parms = {}
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @network_gateways.stub :create_or_update, response do
      assert_raises MsRestAzure::AzureOperationError do
        @service.create_or_update_virtual_network_gateway(network_gateway_parms)
      end
    end
  end
end
