require File.expand_path '../../test_helper', __dir__

# Test class for Check Load Balancer Exists Request
class TestCheckLoadBalancerExists < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    @network_client = @service.instance_variable_get(:@network_client)
    @load_balancers = @network_client.load_balancers
  end

  def test_check_load_balancer_exists_success
    mocked_response = ApiStub::Requests::Network::LoadBalancer.create_load_balancer_response(@network_client)
    @load_balancers.stub :get, mocked_response do
      assert @service.check_load_balancer_exists('fog-test-rg', 'mylb1')
    end
  end

  def test_check_load_balancer_exists_failure
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, mock_response, 'error' => { 'message' => 'mocked exception', 'code' => 'ResourceNotFound' }) }
    @load_balancers.stub :get, response do
      assert !@service.check_load_balancer_exists('fog-test-rg', 'mylb1')
    end
  end

  def test_check_load_balancer_exists_exception
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, mock_response, 'error' => { 'message' => 'mocked exception', 'code' => 'ResourceGroupNotFound' }) }
    @load_balancers.stub :get, response do
      assert !@service.check_load_balancer_exists('fog-test-rg', 'mylb1')
    end
  end
end
