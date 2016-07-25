require File.expand_path '../../test_helper', __dir__

# Test class for Create Load Balancer Request
class TestCreateLoadBalancer < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    client = @service.instance_variable_get(:@network_client)
    @load_balancers = client.load_balancers
    @promise = Concurrent::Promise.execute do
    end
  end

  def test_create_load_balancer_success
    mocked_response = ApiStub::Requests::Network::LoadBalancer.create_load_balancer_response
    expected_response = Azure::ARM::Network::Models::LoadBalancer.serialize_object(mocked_response.body)
    @promise.stub :value!, mocked_response do
      frontend_ip_config = ApiStub::Requests::Network::LoadBalancer.frontend_ip_config
      backend_address_pool = ApiStub::Requests::Network::LoadBalancer.backend_address_pool
      probe = ApiStub::Requests::Network::LoadBalancer.probe
      load_balancing_rule = ApiStub::Requests::Network::LoadBalancer.load_balancing_rule
      inbound_nat_rule = ApiStub::Requests::Network::LoadBalancer.inbound_nat_rule
      inbound_nat_pool = ApiStub::Requests::Network::LoadBalancer.inbound_nat_pool
      @load_balancers.stub :create_or_update, @promise do
        assert_equal @service.create_load_balancer('mylb1', 'North US', 'testRG', frontend_ip_config, backend_address_pool, load_balancing_rule, probe, inbound_nat_rule, inbound_nat_pool), expected_response
      end
    end
  end

  def test_create_load_balancer_argument_error_failure
    response = ApiStub::Requests::Network::LoadBalancer.create_load_balancer_response
    @promise.stub :value!, response do
      @load_balancers.stub :create_or_update, @promise do
        assert_raises ArgumentError do
          @service.create_load_balancer('fog-test-lb', 'West US', 'fog-test-rg')
        end
      end
    end
  end

  def test_create_load_balancer_exception_failure
    response = -> { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @promise.stub :value!, response do
      frontend_ip_config = ApiStub::Requests::Network::LoadBalancer.frontend_ip_config
      backend_address_pool = ApiStub::Requests::Network::LoadBalancer.backend_address_pool
      probe = ApiStub::Requests::Network::LoadBalancer.probe
      load_balancing_rule = ApiStub::Requests::Network::LoadBalancer.load_balancing_rule
      inbound_nat_rule = ApiStub::Requests::Network::LoadBalancer.inbound_nat_rule
      inbound_nat_pool = ApiStub::Requests::Network::LoadBalancer.inbound_nat_pool
      @load_balancers.stub :create_or_update, @promise do
        assert_raises RuntimeError do
          @service.create_load_balancer('mylb1', 'North US', 'testRG', frontend_ip_config, backend_address_pool, load_balancing_rule, probe, inbound_nat_rule, inbound_nat_pool)
        end
      end
    end
  end
end
