require File.expand_path '../../../test_helper', __FILE__

# Test class for Subnet Collection
class TestSubnets < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    @subnets = Fog::Network::AzureRM::Subnets.new(resource_group: 'fog-test-rg', virtual_network_name: 'fog-test-virtual-network', service: @service)
    @network_client = @service.instance_variable_get(:@network_client)
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
    response = [ApiStub::Models::Network::Subnet.create_subnet_response(@network_client)]
    @service.stub :list_subnets, response do
      assert_instance_of Fog::Network::AzureRM::Subnets, @subnets.all
      assert @subnets.all.size >= 1
      @subnets.all.each do |subnet|
        assert_instance_of Fog::Network::AzureRM::Subnet, subnet
      end
    end
  end

  def test_get_method_response
    response = ApiStub::Models::Network::Subnet.create_subnet_response(@network_client)
    @service.stub :get_subnet, response do
      assert_instance_of Fog::Network::AzureRM::Subnet, @subnets.get('fog-test-rg', 'fog-test-vnet', 'fog-test-subnet')
    end
  end
end
