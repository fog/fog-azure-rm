require File.expand_path '../../../test_helper', __FILE__

# Test class for Remove Subnets in Virtual Network Request
class TestRemoveSubnetsInVirtualNetwork < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    @network_client = @service.instance_variable_get(:@network_client)
    @virtual_networks = @network_client.virtual_networks
  end

  def test_remove_subnets_in_virtual_network_success
    mocked_response = ApiStub::Requests::Network::VirtualNetwork.create_virtual_network_response(@network_client)
    mocked_response.subnets.delete_at(0)
    @virtual_networks.stub :get, mocked_response do
      @virtual_networks.stub :create_or_update, mocked_response do
        assert_equal @service.remove_subnets_from_virtual_network('fog-test-rg', 'fog-test-virtual-network', ['mysubnet1']), mocked_response
      end
    end
  end

  def test_remove_subnets_in_virtual_network_failure
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @virtual_networks.stub :get, response do
      assert_raises RuntimeError do
        @service.remove_subnets_from_virtual_network('fog-test-rg', 'fog-test-virtual-network', ['mysubnet1'])
      end
    end
  end
end
