require File.expand_path '../../test_helper', __dir__

# Test class for Delete Network Interface Request
class TestDeleteNetworkInterface < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    client = @service.instance_variable_get(:@network_client)
    @network_interfaces = client.network_interfaces
    @promise = Concurrent::Promise.execute do
    end
  end

  def test_delete_network_interface_success
    response = ApiStub::Requests::Network::NetworkInterface.delete_network_interface_response
    @promise.stub :value!, response do
      @network_interfaces.stub :delete, @promise do
        assert_equal @service.delete_network_interface('fog-test-rg', 'fog-test-network-interface'), response
      end
    end
  end

  def test_delete_network_interface_failure
    response = -> { fail MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @promise.stub :value!, response do
      @network_interfaces.stub :delete, @promise do
        assert_raises(RuntimeError) { @service.delete_network_interface('fog-test-rg', 'fog-test-network-interface') }
      end
    end
  end
end
