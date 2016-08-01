require File.expand_path '../../test_helper', __dir__

# Test class for Get  Network Interface Request
class TestGetNetworkInterface < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    client = @service.instance_variable_get(:@network_client)
    @network_interfaces = client.network_interfaces
    @promise = Concurrent::Promise.execute do
    end
  end

  def test_get_network_interface_success
    mocked_response = ApiStub::Requests::Network::NetworkInterface.create_network_interface_response
    expected_response = Azure::ARM::Network::Models::NetworkInterface.serialize_object(mocked_response.body)
    @promise.stub :value!, mocked_response do
      @network_interfaces.stub :get, @promise do
        assert_equal @service.get_network_interface('fog-test-rg', 'fog-test-network-interface'), expected_response
      end
    end
  end

  def test_get_network_interface_failure
    response = -> { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @promise.stub :value!, response do
      @network_interfaces.stub :get, @promise do
        assert_raises(RuntimeError) { @service.get_network_interface('fog-test-rg', 'fog-test-network-interface') }
      end
    end
  end
end
