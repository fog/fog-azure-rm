require File.expand_path '../../test_helper', __dir__

# Test class for Get Virtual Network request
class TestGetVirtualNetwork < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    @client = @service.instance_variable_get(:@network_client)
    @vnets = @client.virtual_networks
  end

  def test_get_virtual_network_success
    mocked_response = ApiStub::Requests::Network::VirtualNetwork.create_virtual_network_response(@client)
    @vnets.stub :get, mocked_response do
      assert_equal @service.get_virtual_network('fog-test-rg', 'fog-test-virtual-network'), mocked_response
    end
  end

  def test_get_virtual_network_failure
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @vnets.stub :get, response do
      assert_raises Fog::AzureRm::OperationError do
        @service.get_virtual_network('fog-test-rg', 'fog-test-virtual-network')
      end
    end
  end
end
