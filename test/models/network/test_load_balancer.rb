require File.expand_path '../../test_helper', __dir__

class TestLoadBalancer < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    @load_balancer = load_balancer(@service)
  end

  def test_model_methods
    response = ApiStub::Models::Network::LoadBalancer.create_load_balancer_response
    methods = [
      :save,
      :destroy
    ]
    @service.stub :create_load_balancer, response do
      methods.each do |method|
        assert @load_balancer.respond_to? method
      end
    end
  end

  def test_model_attributes
    response = ApiStub::Models::Network::LoadBalancer.create_load_balancer_response
    attributes = [
      :name,
      :id,
      :location,
      :resource_group,
      :frontend_ip_configurations,
      :backend_address_pool_names,
      :load_balancing_rules,
      :probes,
      :inbound_nat_rules,
      :inbound_nat_pools
    ]
    @service.stub :create_load_balancer, response do
      attributes.each do |attribute|
        assert @load_balancer.respond_to? attribute
      end
    end
  end

  def test_save_method_response
    response = ApiStub::Models::Network::LoadBalancer.create_load_balancer_response
    @service.stub :create_load_balancer, response do
      assert_instance_of Fog::Network::AzureRM::LoadBalancer, @load_balancer.save
    end
  end

  def test_destroy_method_response
    @service.stub :delete_load_balancer, true do
      assert @load_balancer.destroy
    end
  end
end
