require File.expand_path '../../test_helper', __dir__

# Test class for Delete Subnet Request
class TestDeleteSubnet < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    client = @service.instance_variable_get(:@network_client)
    @subnets = client.subnets
    @promise = Concurrent::Promise.execute do
    end
  end

  def test_delete_subnet_success
    response = ApiStub::Requests::Network::Subnet.delete_subnet_response
    @promise.stub :value!, response do
      @subnets.stub :delete, @promise do
        assert @service.delete_subnet('fog-test-rg', 'fog-test-subnet', 'fog-test-virtual-network')
      end
    end
  end

  def test_delete_subnet_failure
    response = -> { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @promise.stub :value!, response do
      @subnets.stub :delete, @promise do
        assert_raises(RuntimeError) { @service.delete_subnet('fog-test-rg', 'fog-test-subnet', 'fog-test-virtual-network') }
      end
    end
  end
end
