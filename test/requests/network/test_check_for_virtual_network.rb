require File.expand_path '../../test_helper', __dir__

# Test class for Check for Virtual Network Request
class TestCheckForVirtualNetwork < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    client = @service.instance_variable_get(:@network_client)
    @virtual_networks = client.virtual_networks
    @promise = Concurrent::Promise.execute do
    end
  end

  def test_check_for_virtual_network_success
    @promise.stub :value!, true do
      @virtual_networks.stub :get, @promise do
        assert @service.check_for_virtual_network('fog-test-rg', 'fog-test-virtual-network')
      end
    end
  end

  def test_check_for_virtual_network_failure
    response = -> { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception', 'code' => 'ResourceNotFound' }) }
    @promise.stub :value!, response do
      @virtual_networks.stub :get, @promise do
        assert !@service.check_for_virtual_network('fog-test-rg', 'fog-test-virtual-network')
      end
    end
  end

  def test_check_for_virtual_network_exception
    response = -> { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception', 'code' => 'ResourceGroupNotFound' }) }
    @promise.stub :value!, response do
      @virtual_networks.stub :get, @promise do
        assert_raises(RuntimeError) { @service.check_for_virtual_network('fog-test-rg', 'fog-test-virtual-network') }
      end
    end
  end
end
