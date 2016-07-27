require File.expand_path '../../test_helper', __dir__

# Test class for Network Security Group Collection
class TestNetworkSecurityGroups < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    @network_security_groups = Fog::Network::AzureRM::NetworkSecurityGroups.new(resource_group: 'fog-test-rg', service: @service)
    @response = [ApiStub::Models::Network::NetworkSecurityGroup.create_network_security_group_response]
  end

  def test_collection_methods
    methods = [
      :all,
      :get
    ]
    methods.each do |method|
      assert @network_security_groups.respond_to? method
    end
  end

  def test_collection_attributes
    assert @network_security_groups.respond_to? :resource_group
  end

  def test_all_method_response
    @service.stub :list_network_security_groups, @response do
      assert_instance_of Fog::Network::AzureRM::NetworkSecurityGroups, @network_security_groups.all
      assert @network_security_groups.all.size >= 1
      @network_security_groups.all.each do |nsg|
        assert_instance_of Fog::Network::AzureRM::NetworkSecurityGroup, nsg
      end
    end
  end

  def test_get_method_response
    @service.stub :get_network_security_group, @response[0] do
      assert_instance_of Fog::Network::AzureRM::NetworkSecurityGroup, @network_security_groups.get('fog-test-rg', 'fog-test-nsg')
    end
  end
end
