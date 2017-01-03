require File.expand_path '../../test_helper', __dir__

# Test class for LoadBalancer Collection
class TestLoadBalancers < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    @load_balancers = Fog::Network::AzureRM::LoadBalancers.new(resource_group: 'fog-test-rg', service: @service)
    @network_client = @service.instance_variable_get(:@network_client)
    @response = ApiStub::Models::Network::LoadBalancer.create_load_balancer_response(@network_client)
  end

  def test_collection_methods
    methods = [
      :all,
      :get,
      :check_load_balancer_exists?
    ]
    methods.each do |method|
      assert_respond_to @load_balancers, method
    end
  end

  def test_collection_attributes
    assert_respond_to @load_balancers, :resource_group
  end

  def test_all_method_response
    response = [@response]
    @service.stub :list_load_balancers, response do
      assert_instance_of Fog::Network::AzureRM::LoadBalancers, @load_balancers.all
      assert @load_balancers.all.size >= 1
      @load_balancers.all.each do |lb|
        assert_instance_of Fog::Network::AzureRM::LoadBalancer, lb
      end
    end
  end

  def test_get_method_response
    @service.stub :get_load_balancer, @response do
      assert_instance_of Fog::Network::AzureRM::LoadBalancer, @load_balancers.get('fog-test-rg', 'mylb1')
    end
  end

  def test_check_load_balancer_exists_true_response
    @service.stub :check_load_balancer_exists?, true do
      assert @load_balancers.check_load_balancer_exists?('fog-test-rg', 'mylb1')
    end
  end

  def test_check_load_balancer_exists_false_response
    @service.stub :check_load_balancer_exists?, false do
      assert !@load_balancers.check_load_balancer_exists?('fog-test-rg', 'mylb1')
    end
  end
end
