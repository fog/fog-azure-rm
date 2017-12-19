require File.expand_path '../../test_helper', __dir__

# Test class for Check Local Network Gateway Exists Request
class TestCheckLocalNetworkGatewayExists < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    @network_client = @service.instance_variable_get(:@network_client)
    @local_network_gateways = @network_client.local_network_gateways
  end

  def test_check_local_net_gateway_exists_success
    mocked_response = ApiStub::Requests::Network::LocalNetworkGateway.create_local_network_gateway_response(@network_client)
    @local_network_gateways.stub :get, mocked_response do
      assert @service.check_local_net_gateway_exists('fog-test-rg', 'fog-test-local-network-gateway')
    end
  end

  def test_check_local_net_gateway_exists_failure
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, create_mock_response, 'error' => { 'message' => 'mocked exception', 'code' => 'ResourceNotFound' }) }
    @local_network_gateways.stub :get, response do
      assert !@service.check_local_net_gateway_exists('fog-test-rg', 'fog-test-local-network-gateway')
    end
  end

  def test_check_local_net_gateway_resource_group_exists_failure
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, create_mock_response, 'error' => { 'message' => 'mocked exception', 'code' => 'ResourceGroupNotFound' }) }
    @local_network_gateways.stub :get, response do
      assert !@service.check_local_net_gateway_exists('fog-test-rg', 'fog-test-local-network-gateway')
    end
  end

  def test_check_local_net_gateway_exists_exception
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, create_mock_response, 'error' => { 'message' => 'mocked exception', 'code' => 'Exception' }) }
    @local_network_gateways.stub :get, response do
      assert_raises(RuntimeError) { @service.check_local_net_gateway_exists('fog-test-rg', 'fog-test-local-network-gateway') }
    end
  end
end
