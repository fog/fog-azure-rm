require File.expand_path '../../test_helper', __dir__

# Test class for List Load Balancers Request
class TestListLoadBalancers < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    client = @service.instance_variable_get(:@network_client)
    @load_balancers = client.load_balancers
    @promise = Concurrent::Promise.execute do
    end
  end

  def test_list_load_balancers_success
    mocked_response = ApiStub::Requests::Network::LoadBalancer.list_load_balancers_response
    expected_response = Azure::ARM::Network::Models::LoadBalancerListResult.serialize_object(mocked_response.body)
    @promise.stub :value!, mocked_response do
      @load_balancers.stub :list, @promise do
        assert_equal @service.list_load_balancers('fog-test-rg'), expected_response['value']
      end
    end
  end

  def test_list_load_balancers_failure
    response = -> { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @promise.stub :value!, response do
      @load_balancers.stub :list, @promise do
        assert_raises(RuntimeError) { @service.list_load_balancers('fog-test-rg') }
      end
    end
  end
end
