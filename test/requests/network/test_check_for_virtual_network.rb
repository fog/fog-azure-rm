require File.expand_path '../../../test_helper', __FILE__

# Test class for Check for Virtual Network Request
class TestCheckForVirtualNetwork < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    network_client = @service.instance_variable_get(:@network_client)
    @virtual_networks = network_client.virtual_networks
  end

  def test_check_for_virtual_network_success
    @virtual_networks.stub :get, true do
      assert @service.check_for_virtual_network('fog-test-rg', 'fog-test-virtual-network')
    end
  end

  def test_check_for_virtual_network_failure
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception', 'code' => 'ResourceNotFound' }) }
    @virtual_networks.stub :get, response do
      assert !@service.check_for_virtual_network('fog-test-rg', 'fog-test-virtual-network')
    end
  end

  def test_check_for_virtual_network_exception
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception', 'code' => 'ResourceGroupNotFound' }) }
    @virtual_networks.stub :get, response do
      assert_raises(RuntimeError) { @service.check_for_virtual_network('fog-test-rg', 'fog-test-virtual-network') }
    end
  end
end
