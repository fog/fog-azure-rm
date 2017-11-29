require File.expand_path '../../test_helper', __dir__

# Test class for Check Virtual Network Gateway Exists Request
class TestCheckVirtualNetworkGatewayExists < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    @network_client = @service.instance_variable_get(:@network_client)
    @network_gateways = @network_client.virtual_network_gateways
  end

  def test_check_vnet_gateway_exists_success
    mocked_response = ApiStub::Requests::Network::VirtualNetworkGateway.create_virtual_network_gateway_response(@network_client)
    @network_gateways.stub :get, mocked_response do
      assert_equal @service.check_vnet_gateway_exists('fog-test-rg', 'fog-test-network-gateway'), true
    end
  end

  def test_check_vnet_gateway_exists_failure
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, get_mock_response, 'error' => { 'message' => 'mocked exception', 'code' => 'ResourceNotFound' }) }
    @network_gateways.stub :get, response do
      assert !@service.check_vnet_gateway_exists('fog-test-rg', 'fog-test-network-gateway')
    end
  end

  def test_check_vnet_gateway_exists_exception
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, get_mock_response, 'error' => { 'message' => 'mocked exception', 'code' => 'ResourceGroupNotFound' }) }
    @network_gateways.stub :get, response do
      assert !@service.check_vnet_gateway_exists('fog-test-rg', 'fog-test-network-gateway')
    end
  end
end
