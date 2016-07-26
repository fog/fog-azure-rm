require File.expand_path '../../test_helper', __dir__

# Test class for LoadBalancer Collection
class TestLoadBalancers < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    @load_balancers = Fog::Network::AzureRM::LoadBalancers.new(resource_group: 'fog-test-rg', service: @service)
  end

  def test_collection_methods
    methods = [
      :all,
      :get
    ]
    methods.each do |method|
      assert @load_balancers.respond_to? method
    end
  end

  def test_collection_attributes
    assert @load_balancers.respond_to? :resource_group
  end

  def test_all_method_response
    response = [ApiStub::Models::Network::LoadBalancer.create_load_balancer_response]
    @service.stub :list_load_balancers, response do
      assert_instance_of Fog::Network::AzureRM::LoadBalancers, @load_balancers.all
      assert @load_balancers.all.size >= 1
      @load_balancers.all.each do |lb|
        assert_instance_of Fog::Network::AzureRM::LoadBalancer, lb
      end
    end
  end

  def test_get_method_response
    response = [ApiStub::Models::Network::LoadBalancer.create_load_balancer_response]
    @service.stub :list_load_balancers, response do
      assert_instance_of Fog::Network::AzureRM::LoadBalancer, @load_balancers.get('mylb1')
      assert @load_balancers.get('wrong-name').nil?, true
    end
  end
end
