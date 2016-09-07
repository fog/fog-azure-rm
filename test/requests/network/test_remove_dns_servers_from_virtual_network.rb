require File.expand_path '../../../test_helper', __FILE__

# Test class for Remove Dns Servers in Virtual Network Request
class TestRemoveDnsServersInVirtualNetwork < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    @network_client = @service.instance_variable_get(:@network_client)
    @virtual_networks = @network_client.virtual_networks
  end

  def test_remove_dns_servers_in_virtual_network_success
    mocked_response = ApiStub::Requests::Network::VirtualNetwork.create_virtual_network_response(@network_client)
    mocked_response.dhcp_options.dns_servers.delete('10.1.0.5')
    @virtual_networks.stub :get, mocked_response do
      @virtual_networks.stub :create_or_update, mocked_response do
        assert_equal @service.remove_dns_servers_from_virtual_network('fog-test-rg', 'fog-test-virtual-network', ['10.1.0.5']), mocked_response
      end
    end
  end

  def test_remove_dns_servers_in_virtual_network_failure
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @virtual_networks.stub :get, response do
      assert_raises RuntimeError do
        @service.remove_dns_servers_from_virtual_network('fog-test-rg', 'fog-test-virtual-network', ['10.1.0.5'])
      end
    end
  end
end
