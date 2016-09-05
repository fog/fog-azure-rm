require File.expand_path '../../test_helper', __dir__

# Test class for NetworkInterface Collection
class TestNetworkInterfaces < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    @network_interfaces = Fog::Network::AzureRM::NetworkInterfaces.new(resource_group: 'fog-test-rg', service: @service)
    @network_client = @service.instance_variable_get(:@network_client)
  end

  def test_collection_methods
    methods = [
      :all,
      :get
    ]
    methods.each do |method|
      assert @network_interfaces.respond_to? method
    end
  end

  def test_collection_attributes
    assert @network_interfaces.respond_to? :resource_group
  end

  def test_all_method_response
    response = [ApiStub::Models::Network::NetworkInterface.create_network_interface_response(@network_client)]
    @service.stub :list_network_interfaces, response do
      assert_instance_of Fog::Network::AzureRM::NetworkInterfaces, @network_interfaces.all
      assert @network_interfaces.all.size >= 1
      @network_interfaces.all.each do |nic|
        assert_instance_of Fog::Network::AzureRM::NetworkInterface, nic
      end
    end
  end

  def test_get_method_response
    response = ApiStub::Models::Network::NetworkInterface.create_network_interface_response(@network_client)
    @service.stub :get_network_interface, response do
      assert_instance_of Fog::Network::AzureRM::NetworkInterface, @network_interfaces.get('fog-test-rg', 'fog-test-network-interface')
    end
  end
end
