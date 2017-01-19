require File.expand_path '../../test_helper', __dir__

# Test class for Check Virtual Network Exists Request
class TestCheckVirtualNetworkExists < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    network_client = @service.instance_variable_get(:@network_client)
    @virtual_networks = network_client.virtual_networks
  end

  def test_check_virtual_network_exists_success
    @virtual_networks.stub :get, true do
      assert @service.check_virtual_network_exists('fog-test-rg', 'fog-test-virtual-network')
    end
  end

  def test_check_virtual_network_exists_failure
    faraday_response = Faraday::Response.new(nil)
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, faraday_response, 'error' => { 'message' => 'mocked exception', 'code' => 'ResourceNotFound' }) }

    faraday_response.stub :status, '404' do
      @virtual_networks.stub :get, response do
        assert !@service.check_virtual_network_exists('fog-test-rg', 'fog-test-virtual-network')
      end
    end
  end

  def test_check_virtual_network_exists_exception
    faraday_response = Faraday::Response.new(nil)
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, faraday_response, 'error' => { 'message' => 'mocked exception', 'code' => 'ResourceGroupNotFound' }) }

    faraday_response.stub :status, '400' do
      @virtual_networks.stub :get, response do
        assert_raises(RuntimeError) { @service.check_virtual_network_exists('fog-test-rg', 'fog-test-virtual-network') }
      end
    end
  end
end
