require File.expand_path '../../../test_helper', __FILE__

# Test class for Delete Load Balancer Request
class TestDeleteLoadBalancer < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    network_client = @service.instance_variable_get(:@network_client)
    @load_balancers = network_client.load_balancers
  end

  def test_delete_load_balancer_success
    response = true
    @load_balancers.stub :delete, true do
      assert @service.delete_load_balancer('fog-test-rg', 'fog-test-load-balancer'), response
    end
  end

  def test_delete_load_balancer_failure
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @load_balancers.stub :delete, response do
      assert_raises(RuntimeError) { @service.delete_load_balancer('fog-test-rg', 'fog-test-load-balancer') }
    end
  end
end
