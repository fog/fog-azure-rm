require File.expand_path '../../test_helper', __dir__

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
      :get,
      :check_subnet_exists
    ]
    methods.each do |method|
      assert_respond_to @subnets, method
    end
  end

  def test_collection_attributes
    assert_respond_to @subnets, :resource_group
    assert_respond_to @subnets, :virtual_network_name
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

  def test_check_subnet_exists_true_response
    @service.stub :check_subnet_exists, true do
      assert @subnets.check_subnet_exists('fog-test-rg', 'fog-test-vnet', 'fog-test-subnet')
    end
  end

  def test_check_subnet_exists_false_response
    @service.stub :check_subnet_exists, false do
      assert !@subnets.check_subnet_exists('fog-test-rg', 'fog-test-vnet', 'fog-test-subnet')
    end
  end
end
