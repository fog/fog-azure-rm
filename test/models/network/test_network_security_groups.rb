require File.expand_path '../../test_helper', __dir__

# Test class for Network Security Group Collection
class TestNetworkSecurityGroups < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    client = @service.instance_variable_get(:@network_client)
    @network_security_groups = Fog::Network::AzureRM::NetworkSecurityGroups.new(resource_group: 'fog-test-rg', service: @service)
    @response = [ApiStub::Models::Network::NetworkSecurityGroup.create_network_security_group_response(client)]
  end

  def test_collection_methods
    methods = [
      :all,
      :get,
      :check_net_sec_group_exists
    ]
    methods.each do |method|
      assert_respond_to @network_security_groups, method
    end
  end

  def test_collection_attributes
    assert_respond_to @network_security_groups, :resource_group
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

  def test_check_net_sec_group_exists_true_response
    @service.stub :check_net_sec_group_exists, true do
      assert @network_security_groups.check_net_sec_group_exists('fog-test-rg', 'fog-test-nsg')
    end
  end

  def test_check_net_sec_group_exists_false_response
    @service.stub :check_net_sec_group_exists, false do
      assert !@network_security_groups.check_net_sec_group_exists('fog-test-rg', 'fog-test-nsg')
    end
  end
end
