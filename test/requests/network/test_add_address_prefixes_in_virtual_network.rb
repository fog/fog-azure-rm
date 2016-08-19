require File.expand_path '../../test_helper', __dir__

# Test class for Add Address Prefixes in Virtual Network Request
class TestAddAddressPrefixesInVirtualNetwork < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    @client = @service.instance_variable_get(:@network_client)
    @virtual_networks = @client.virtual_networks
  end

  def test_add_address_prefixes_in_virtual_network_success
    mocked_response = ApiStub::Requests::Network::VirtualNetwork.create_virtual_network_response(@client)
    mocked_response.address_space.address_prefixes.push('10.3.0.0/16', '10.4.0.0/16')
    @virtual_networks.stub :get, mocked_response do
      @virtual_networks.stub :create_or_update, mocked_response do
        assert_equal @service.add_address_prefixes_in_virtual_network('fog-test-rg', 'fog-test-virtual-network', ['10.3.0.0/16', '10.4.0.0/16']), mocked_response
      end
    end
  end

  def test_add_address_prefixes_in_virtual_network_failure
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @virtual_networks.stub :get, response do
      assert_raises Fog::AzureRm::OperationError do
        @service.add_address_prefixes_in_virtual_network('fog-test-rg', 'fog-test-virtual-network', ['10.1.0.0/16', '10.2.0.0/16'])
      end
    end
  end
end
