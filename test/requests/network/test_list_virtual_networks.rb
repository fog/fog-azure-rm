require File.expand_path '../../test_helper', __dir__

# Test class for List Virtual Networks Request
class TestListVirtualNetworks < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    client = @service.instance_variable_get(:@network_client)
    @virtual_networks = client.virtual_networks
    @promise = Concurrent::Promise.execute do
    end
  end

  def test_list_virtual_networks_success
    mocked_response = ApiStub::Requests::Network::VirtualNetwork.list_virtual_networks_response
    expected_response = Azure::ARM::Network::Models::VirtualNetworkListResult.serialize_object(mocked_response.body)
    @promise.stub :value!, mocked_response do
      @virtual_networks.stub :list, @promise do
        assert_equal @service.list_virtual_networks('fog-test-rg'), expected_response['value']
      end
    end
  end

  def test_list_virtual_networks_failure
    response = -> { fail MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @promise.stub :value!, response do
      @virtual_networks.stub :list, @promise do
        assert_raises(RuntimeError) { @service.list_virtual_networks('fog-test-rg') }
      end
    end
  end
end
