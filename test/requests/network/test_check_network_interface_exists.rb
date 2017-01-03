require File.expand_path '../../test_helper', __dir__

# Test class for Check Network Interface Exists Request
class TestCheckNetworkInterfaceExists < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    @network_client = @service.instance_variable_get(:@network_client)
    @network_interfaces = @network_client.network_interfaces
  end

  def test_check_network_interface_exists_success
    mocked_response = ApiStub::Requests::Network::NetworkInterface.create_network_interface_response(@network_client)
    @network_interfaces.stub :get, mocked_response do
      assert @service.check_network_interface_exists?('fog-test-rg', 'fog-test-network-interface')
    end
  end

  def test_check_network_interface_exists_failure
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception', 'code' => 'ResourceNotFound' }) }
    @network_interfaces.stub :get, response do
      assert !@service.check_network_interface_exists?('fog-test-rg', 'fog-test-network-interface')
    end
  end

  def test_check_network_interface_exists_exception
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception', 'code' => 'ResourceGroupNotFound' }) }
    @network_interfaces.stub :get, response do
      assert_raises(RuntimeError) { @service.check_network_interface_exists?('fog-test-rg', 'fog-test-network-interface') }
    end
  end
end
