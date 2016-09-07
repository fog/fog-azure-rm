require File.expand_path '../../../test_helper', __FILE__

# Test class for Create Load Balancer Request
class TestCreateLoadBalancer < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    @network_client = @service.instance_variable_get(:@network_client)
    @load_balancers = @network_client.load_balancers
  end

  def test_create_load_balancer_success
    mocked_response = ApiStub::Requests::Network::LoadBalancer.create_load_balancer_response(@network_client)

    frontend_ip_config = ApiStub::Requests::Network::LoadBalancer.frontend_ip_config
    backend_address_pool = ApiStub::Requests::Network::LoadBalancer.backend_address_pool
    probe = ApiStub::Requests::Network::LoadBalancer.probe
    load_balancing_rule = ApiStub::Requests::Network::LoadBalancer.load_balancing_rule
    inbound_nat_rule = ApiStub::Requests::Network::LoadBalancer.inbound_nat_rule
    inbound_nat_pool = ApiStub::Requests::Network::LoadBalancer.inbound_nat_pool
    @load_balancers.stub :create_or_update, mocked_response do
      assert_equal @service.create_load_balancer('mylb1', 'North US', 'testRG', frontend_ip_config, backend_address_pool, load_balancing_rule, probe, inbound_nat_rule, inbound_nat_pool), mocked_response
    end
  end

  def test_create_load_balancer_argument_error_failure
    response = ApiStub::Requests::Network::LoadBalancer.create_load_balancer_response(@network_client)
    @load_balancers.stub :create_or_update, response do
      assert_raises ArgumentError do
        @service.create_load_balancer('fog-test-lb', 'West US', 'fog-test-rg')
      end
    end
  end

  def test_create_load_balancer_exception_failure
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }

    frontend_ip_config = ApiStub::Requests::Network::LoadBalancer.frontend_ip_config
    backend_address_pool = ApiStub::Requests::Network::LoadBalancer.backend_address_pool
    probe = ApiStub::Requests::Network::LoadBalancer.probe
    load_balancing_rule = ApiStub::Requests::Network::LoadBalancer.load_balancing_rule
    inbound_nat_rule = ApiStub::Requests::Network::LoadBalancer.inbound_nat_rule
    inbound_nat_pool = ApiStub::Requests::Network::LoadBalancer.inbound_nat_pool
    @load_balancers.stub :create_or_update, response do
      assert_raises RuntimeError do
        @service.create_load_balancer('mylb1', 'North US', 'testRG', frontend_ip_config, backend_address_pool, load_balancing_rule, probe, inbound_nat_rule, inbound_nat_pool)
      end
    end
  end
end
