require File.expand_path '../../test_helper', __dir__

# Test class for Network Security Rule Collection
class TestNetworkSecurityRules < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    client = @service.instance_variable_get(:@network_client)
    @network_security_rules = Fog::Network::AzureRM::NetworkSecurityRules.new(resource_group: 'fog-test-rg', network_security_group_name: 'fog-test-nsg', service: @service)
    @response = [ApiStub::Models::Network::NetworkSecurityRule.create_network_security_rule_response(client)]
  end

  def test_collection_methods
    methods = [
      :all,
      :get
    ]
    methods.each do |method|
      assert @network_security_rules.respond_to? method
    end
  end

  def test_collection_attributes
    assert @network_security_rules.respond_to? :resource_group
    assert @network_security_rules.respond_to? :network_security_group_name
  end

  def test_all_method_response
    @service.stub :list_network_security_rules, @response do
      assert_instance_of Fog::Network::AzureRM::NetworkSecurityRules, @network_security_rules.all
      assert @network_security_rules.all.size >= 1
      @network_security_rules.all.each do |nsr|
        assert_instance_of Fog::Network::AzureRM::NetworkSecurityRule, nsr
      end
    end
  end

  def test_get_method_response
    @service.stub :get_network_security_rule, @response[0] do
      assert_instance_of Fog::Network::AzureRM::NetworkSecurityRule, @network_security_rules.get('fog-test-rg', 'fog-test-nsg', 'fog-test-nsr')
    end
  end
end
