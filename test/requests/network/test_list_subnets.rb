require File.expand_path '../../test_helper', __dir__

# Test class for List Subnets Request
class TestListSubnets < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    client = @service.instance_variable_get(:@network_client)
    @subnets = client.subnets
    @promise = Concurrent::Promise.execute do
    end
  end

  def test_list_subnets_success
    response = ApiStub::Requests::Network::Subnet.list_subnets_response
    @promise.stub :value!, response do
      @subnets.stub :list, @promise do
        assert @service.list_subnets('fog-test-rg', 'fog-test-virtual-network'), response
      end
    end
  end

  def test_list_subnets_failure
    response = -> { fail MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @promise.stub :value!, response do
      @subnets.stub :list, @promise do
        assert_raises(RuntimeError) { @service.list_subnets('fog-test-rg', 'fog-test-virtual-network') }
      end
    end
  end
end
