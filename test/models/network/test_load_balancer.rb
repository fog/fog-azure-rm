require File.expand_path '../../test_helper', __dir__

# Test class for LoadBalancer Model
class TestLoadBalancer < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    @load_balancer = load_balancer(@service)
    network_client = @service.instance_variable_get(:@network_client)
    @response = ApiStub::Models::Network::LoadBalancer.create_load_balancer_response(network_client)
  end

  def test_model_methods
    methods = [
      :save,
      :destroy
    ]
    methods.each do |method|
      assert_respond_to @load_balancer, method
    end
  end

  def test_model_attributes
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
    attributes.each do |attribute|
      assert_respond_to @load_balancer, attribute
    end
  end

  def test_save_method_response
    @service.stub :create_load_balancer, @response do
      assert_instance_of Fog::Network::AzureRM::LoadBalancer, @load_balancer.save
    end
  end

  def test_destroy_method_response
    @service.stub :delete_load_balancer, true do
      assert @load_balancer.destroy
    end
  end
end
