require File.expand_path '../../test_helper', __dir__

# Test class for Delete Sql Server Firewall Rule
class TestDeleteFirewallRule < Minitest::Test
  def setup
    @service = Fog::Sql::AzureRM.new(credentials)
    @sql_manager_client = @service.instance_variable_get(:@sql_mgmt_client)
    @firewall_rules = @sql_manager_client.servers
  end

  def test_delete_sql_server_firewall_rule_success
    @firewall_rules.stub :delete_firewall_rule, true do
      assert @service.delete_firewall_rule('fog-test-rg', 'fog-test-server-name', 'rule-name')
    end
  end

  def test_delete_sql_server_firewall_rule_failure
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @firewall_rules.stub :delete_firewall_rule, response do
      assert_raises(MsRestAzure::AzureOperationError) { @service.delete_firewall_rule('fog-test-rg', 'fog-test-server-name', 'rule-name') }
    end
  end
end
