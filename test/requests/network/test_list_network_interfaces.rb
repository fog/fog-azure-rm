require File.expand_path '../../test_helper', __dir__

# Test class for List Network Interfaces Request
class TestListNetworkInterfaces < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    client = @service.instance_variable_get(:@network_client)
    @network_interfaces = client.network_interfaces
    @promise = Concurrent::Promise.execute do
    end
  end

  def test_list_network_interfaces_success
    mocked_response = ApiStub::Requests::Network::NetworkInterface.list_network_interfaces_response
    expected_response = Azure::ARM::Network::Models::NetworkInterfaceListResult.serialize_object(mocked_response.body)
    @promise.stub :value!, mocked_response do
      @network_interfaces.stub :list, @promise do
        assert_equal @service.list_network_interfaces('fog-test-rg'), expected_response['value']
      end
    end
  end

  def test_list_network_interfaces_failure
    response = -> { fail MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @promise.stub :value!, response do
      @network_interfaces.stub :list, @promise do
        assert_raises(RuntimeError) { @service.list_network_interfaces('fog-test-rg') }
      end
    end
  end
end
