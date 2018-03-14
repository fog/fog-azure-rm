require File.expand_path '../../test_helper', __dir__

# Test class for Get  Load Balancer Request
class TestGetLoadBalancer < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    @network_client = @service.instance_variable_get(:@network_client)
    @load_balancers = @network_client.load_balancers
  end

  def test_get_load_balancer_success
    mocked_response = ApiStub::Requests::Network::LoadBalancer.create_load_balancer_response(@network_client)
    @load_balancers.stub :get, mocked_response do
      assert_equal @service.get_load_balancer('fog-test-rg', 'mylb1'), mocked_response
    end
  end

  def test_get_load_balancer_failure
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @load_balancers.stub :get, response do
      assert_raises(MsRestAzure::AzureOperationError) { @service.get_load_balancer('fog-test-rg', 'mylb1') }
    end
  end
end
