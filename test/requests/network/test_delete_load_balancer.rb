require File.expand_path '../../test_helper', __dir__

# Test class for Delete Load Balancer Request
class TestDeleteLoadBalancer < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    client = @service.instance_variable_get(:@network_client)
    @load_balancers = client.load_balancers
    @promise = Concurrent::Promise.execute do
    end
  end

  def test_delete_load_balancer_success
    response = true
    @promise.stub :value!, response do
      @load_balancers.stub :delete, @promise do
        assert @service.delete_load_balancer('fog-test-rg', 'fog-test-load-balancer'), response
      end
    end
  end

  def test_delete_load_balancer_failure
    response = -> { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @promise.stub :value!, response do
      @load_balancers.stub :delete, @promise do
        assert_raises(RuntimeError) { @service.delete_load_balancer('fog-test-rg', 'fog-test-load-balancer') }
      end
    end
  end
end
