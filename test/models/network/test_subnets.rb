require File.expand_path '../../test_helper', __dir__

# Test class for Subnet Collection
class TestSubnets < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    @subnets = Fog::Network::AzureRM::Subnets.new(resource_group: 'fog-test-rg', virtual_network_name: 'fog-test-virtual-network', service: @service)
  end

  def test_collection_methods
    methods = [
      :all,
      :get
    ]
    methods.each do |method|
      assert @subnets.respond_to? method
    end
  end

  def test_collection_attributes
    assert @subnets.respond_to? :resource_group
    assert @subnets.respond_to? :virtual_network_name
  end

  def test_all_method_response
    response = [ApiStub::Models::Network::Subnet.create_subnet_response]
    @service.stub :list_subnets, response do
      assert_instance_of Fog::Network::AzureRM::Subnets, @subnets.all
      assert @subnets.all.size >= 1
      @subnets.all.each do |subnet|
        assert_instance_of Fog::Network::AzureRM::Subnet, subnet
      end
    end
  end

  def test_get_method_response
    response = [ApiStub::Models::Network::Subnet.create_subnet_response]
    @service.stub :list_subnets, response do
      assert_instance_of Fog::Network::AzureRM::Subnet, @subnets.get('fog-test-subnet')
      assert @subnets.get('wrong-name').nil?
    end
  end
end
