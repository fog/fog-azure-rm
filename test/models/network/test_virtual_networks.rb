require File.expand_path '../../test_helper', __dir__

# Test class for VirtualNetwork Collection
class TestVirtualNetworks < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    @virtual_networks = Fog::Network::AzureRM::VirtualNetworks.new(resource_group: 'fog-test-rg', service: @service)
    @network_client = @service.instance_variable_get(:@network_client)
  end

  def test_collection_methods
    methods = [
      :all,
      :get,
      :check_virtual_network_exists?
    ]
    methods.each do |method|
      assert_respond_to @virtual_networks, method
    end
  end

  def test_collection_attributes
    assert_respond_to @virtual_networks, :resource_group
  end

  def test_all_method_response_for_rg
    response = [ApiStub::Models::Network::VirtualNetwork.create_virtual_network_response(@network_client)]
    @service.stub :list_virtual_networks, response do
      assert_instance_of Fog::Network::AzureRM::VirtualNetworks, @virtual_networks.all
      assert @virtual_networks.all.size >= 1
      @virtual_networks.all.each do |nic|
        assert_instance_of Fog::Network::AzureRM::VirtualNetwork, nic
      end
    end
  end

  def test_all_method_response
    virtual_networks = Fog::Network::AzureRM::VirtualNetworks.new(service: @service)
    response = [ApiStub::Models::Network::VirtualNetwork.create_virtual_network_response(@network_client)]
    @service.stub :list_virtual_networks_in_subscription, response do
      assert_instance_of Fog::Network::AzureRM::VirtualNetworks, virtual_networks.all
      assert virtual_networks.all.size >= 1
      virtual_networks.all.each do |nic|
        assert_instance_of Fog::Network::AzureRM::VirtualNetwork, nic
      end
    end
  end

  def test_get_method_response
    response = ApiStub::Models::Network::VirtualNetwork.create_virtual_network_response(@network_client)
    @service.stub :get_virtual_network, response do
      assert_instance_of Fog::Network::AzureRM::VirtualNetwork, @virtual_networks.get('fog-rg', 'fog-test-virtual-network')
    end
  end

  def test_check_virtual_network_exists_method_success
    @service.stub :check_virtual_network_exists?, true do
      assert @virtual_networks.check_virtual_network_exists?('fog-rg', 'fog-test-virtual-network')
    end
  end

  def test_check_virtual_network_exists_method_failure
    @service.stub :check_virtual_network_exists?, false do
      assert !@virtual_networks.check_virtual_network_exists?('fog-rg', 'fog-test-virtual-network')
    end
  end
end
