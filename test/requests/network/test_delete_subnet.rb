require File.expand_path '../../test_helper', __dir__

# Test class for Delete Subnet Request
class TestDeleteSubnet < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    @network_client = @service.instance_variable_get(:@network_client)
    @subnets = @network_client.subnets
  end

  def test_delete_subnet_success
    response = ApiStub::Requests::Network::Subnet.delete_subnet_response
    @subnets.stub :delete, response do
      assert @service.delete_subnet('fog-test-rg', 'fog-test-subnet', 'fog-test-virtual-network')
    end
  end

  def test_delete_subnet_failure
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @subnets.stub :delete, response do
      assert_raises(MsRestAzure::AzureOperationError) { @service.delete_subnet('fog-test-rg', 'fog-test-subnet', 'fog-test-virtual-network') }
    end
  end
end
