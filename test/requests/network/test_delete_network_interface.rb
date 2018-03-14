require File.expand_path '../../test_helper', __dir__

# Test class for Delete Network Interface Request
class TestDeleteNetworkInterface < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    network_client = @service.instance_variable_get(:@network_client)
    @network_interfaces = network_client.network_interfaces
  end

  def test_delete_network_interface_success
    response = ApiStub::Requests::Network::NetworkInterface.delete_network_interface_response
    @network_interfaces.stub :delete, @promise do
      assert @service.delete_network_interface('fog-test-rg', 'fog-test-network-interface'), response
    end
  end

  def test_delete_network_interface_failure
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @network_interfaces.stub :delete, response do
      assert_raises(MsRestAzure::AzureOperationError) { @service.delete_network_interface('fog-test-rg', 'fog-test-network-interface') }
    end
  end
end
