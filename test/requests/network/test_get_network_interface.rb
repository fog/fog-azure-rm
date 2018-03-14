require File.expand_path '../../test_helper', __dir__

# Test class for Get  Network Interface Request
class TestGetNetworkInterface < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    @network_client = @service.instance_variable_get(:@network_client)
    @network_interfaces = @network_client.network_interfaces
  end

  def test_get_network_interface_success
    mocked_response = ApiStub::Requests::Network::NetworkInterface.create_network_interface_response(@network_client)
    @network_interfaces.stub :get, mocked_response do
      assert_equal @service.get_network_interface('fog-test-rg', 'fog-test-network-interface'), mocked_response
    end
  end

  def test_get_network_interface_failure
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @network_interfaces.stub :get, response do
      assert_raises(MsRestAzure::AzureOperationError) { @service.get_network_interface('fog-test-rg', 'fog-test-network-interface') }
    end
  end
end
