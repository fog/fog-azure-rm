require File.expand_path '../../../test_helper', __FILE__

# Test class for Get Virtual Network request
class TestGetVirtualNetwork < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    @network_client = @service.instance_variable_get(:@network_client)
    @virtual_networks = @network_client.virtual_networks
  end

  def test_get_virtual_network_success
    mocked_response = ApiStub::Requests::Network::VirtualNetwork.create_virtual_network_response(@network_client)
    @virtual_networks.stub :get, mocked_response do
      assert_equal @service.get_virtual_network('fog-test-rg', 'fog-test-virtual-network'), mocked_response
    end
  end

  def test_get_virtual_network_failure
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @virtual_networks.stub :get, response do
      assert_raises RuntimeError do
        @service.get_virtual_network('fog-test-rg', 'fog-test-virtual-network')
      end
    end
  end
end
