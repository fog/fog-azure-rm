require File.expand_path '../../test_helper', __dir__

# Test class for VirtualNetwork Collection
class TestVirtualNetworks < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    @virtual_networks = Fog::Network::AzureRM::VirtualNetworks.new(resource_group: 'fog-test-rg', service: @service)
  end

  def test_collection_methods
    methods = [
      :all,
      :get,
      :check_if_exists
    ]
    methods.each do |method|
      assert @virtual_networks.respond_to? method
    end
  end

  def test_collection_attributes
    assert @virtual_networks.respond_to? :resource_group
  end

  def test_all_method_response
    response = [ApiStub::Models::Network::VirtualNetwork.create_virtual_network_response]
    @service.stub :list_virtual_networks, response do
      assert_instance_of Fog::Network::AzureRM::VirtualNetworks, @virtual_networks.all
      assert @virtual_networks.all.size >= 1
      @virtual_networks.all.each do |nic|
        assert_instance_of Fog::Network::AzureRM::VirtualNetwork, nic
      end
    end
  end

  def test_get_method_response
    response = [ApiStub::Models::Network::VirtualNetwork.create_virtual_network_response]
    @service.stub :list_virtual_networks, response do
      assert_instance_of Fog::Network::AzureRM::VirtualNetwork, @virtual_networks.get('fog-test-virtual-network')
      assert @virtual_networks.get('wrong-name').nil?, true
    end
  end

  def test_check_if_exists_method_success
    @service.stub :check_for_virtual_network, true do
      assert @virtual_networks.check_if_exists('fog-test-rg', 'fog-test-virtual-network')
    end
  end

  def test_check_if_exists_method_failure
    @service.stub :check_for_virtual_network, false do
      assert !@virtual_networks.check_if_exists('fog-test-rg', 'fog-test-virtual-network')
    end
  end
end
