require File.expand_path '../../test_helper', __dir__

# Test class for Add Subnets in Virtual Network Request
class TestAddSubnetsInVirtualNetwork < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    @network_client = @service.instance_variable_get(:@network_client)
    @virtual_networks = @network_client.virtual_networks
  end

  def test_add_subnets_in_virtual_network_success
    mocked_response = ApiStub::Requests::Network::VirtualNetwork.create_virtual_network_response(@network_client)
    mocked_response.subnets.unshift('properties' => { 'addressPrefix' => '10.0.0.0/16' }, 'name' => 'test-subnet')
    @virtual_networks.stub :get, mocked_response do
      @virtual_networks.stub :create_or_update, mocked_response do
        assert_equal @service.add_subnets_in_virtual_network('fog-test-rg', 'fog-test-virtual-network', [{ name: 'test-subnet', address_prefix: '10.0.0.0/16' }]), mocked_response
      end
    end
  end

  def test_add_subnets_in_virtual_network_failure
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @virtual_networks.stub :get, response do
      assert_raises RuntimeError do
        @service.add_subnets_in_virtual_network('fog-test-rg', 'fog-test-virtual-network', @subnets)
      end
    end
  end
end
