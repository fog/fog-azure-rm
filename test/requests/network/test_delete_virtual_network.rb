require File.expand_path '../../test_helper', __dir__

# Test class for Delete Virtual Network Request
class TestDeleteVirtualNetwork < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    client = @service.instance_variable_get(:@network_client)
    @virtual_networks = client.virtual_networks
    @promise = Concurrent::Promise.execute do
    end
  end

  def test_delete_virtual_network_success
    response = ApiStub::Requests::Network::VirtualNetwork.delete_virtual_network_response
    @promise.stub :value!, response do
      @virtual_networks.stub :delete, @promise do
        assert @service.delete_virtual_network('fog-test-rg', 'fog-test-virtual-network')
      end
    end
  end

  def test_delete_virtual_network_failure
    response = -> { fail MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @promise.stub :value!, response do
      @virtual_networks.stub :delete, @promise do
        assert_raises(RuntimeError) { @service.delete_virtual_network('fog-test-rg', 'fog-test-virtual-network') }
      end
    end
  end
end
