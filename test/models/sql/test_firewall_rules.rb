require File.expand_path '../../test_helper', __dir__

# Test class for Sql Server Firewall Rule Collection
class TestFirewallRules < Minitest::Test
  def setup
    @service = Fog::Sql::AzureRM.new(credentials)
    @firewall_rules = sql_server_firewall_rules(@service)
    @firewall_client = @service.instance_variable_get(:@sql_mgmt_client)
    @create_firewall_rule_response = ApiStub::Models::Sql::SqlFirewallRule.create_firewall_rule(@firewall_client)
  end

  def test_collection_methods
    methods = [
      :all,
      :get
    ]
    methods.each do |method|
      assert_respond_to @firewall_rules, method
    end
  end

  def test_collection_attributes
    assert_respond_to @firewall_rules, :resource_group
  end

  def test_all_method_response
    list_firewall_rule_response = [@create_firewall_rule_response]
    @service.stub :list_firewall_rules, list_firewall_rule_response do
      assert_instance_of Fog::Sql::AzureRM::FirewallRules, @firewall_rules.all
      assert @firewall_rules.all.size >= 1
      @firewall_rules.all.each do |s|
        assert_instance_of Fog::Sql::AzureRM::FirewallRule, s
      end
    end
  end

  def test_get_method_response
    @service.stub :get_firewall_rule, @create_firewall_rule_response do
      assert_instance_of Fog::Sql::AzureRM::FirewallRule, @firewall_rules.get('fog-test-rg', 'fog-test-server-name', 'fog-test-rule-name')
    end
  end
end
