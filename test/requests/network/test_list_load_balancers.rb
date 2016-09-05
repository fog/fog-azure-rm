require File.expand_path '../../../test_helper', __FILE__

# Test class for List Load Balancers Request
class TestListLoadBalancers < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    @network_client = @service.instance_variable_get(:@network_client)
    @load_balancers = @network_client.load_balancers
  end

  def test_list_load_balancers_success
    mocked_response = ApiStub::Requests::Network::LoadBalancer.list_load_balancers_response(@network_client)
    @load_balancers.stub :list_as_lazy, mocked_response do
      assert_equal @service.list_load_balancers('fog-test-rg'), mocked_response.value
    end
  end

  def test_list_load_balancers_failure
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @load_balancers.stub :list_as_lazy, response do
      assert_raises(RuntimeError) { @service.list_load_balancers('fog-test-rg') }
    end
  end
end
