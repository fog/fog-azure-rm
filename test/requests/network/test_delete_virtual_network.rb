require File.expand_path '../../test_helper', __dir__

# Test class for Delete Virtual Network Request
class TestDeleteVirtualNetwork < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    @network_client = @service.instance_variable_get(:@network_client)
    @virtual_networks = @network_client.virtual_networks
  end

  def test_delete_virtual_network_success
    response = ApiStub::Requests::Network::VirtualNetwork.delete_virtual_network_response
    @virtual_networks.stub :delete, response do
      assert @service.delete_virtual_network('fog-test-rg', 'fog-test-virtual-network')
    end
  end

  def test_delete_virtual_network_failure
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @virtual_networks.stub :delete, response do
      assert_raises(RuntimeError) { @service.delete_virtual_network('fog-test-rg', 'fog-test-virtual-network') }
    end
  end
end
