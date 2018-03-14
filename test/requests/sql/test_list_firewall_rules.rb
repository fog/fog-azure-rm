require File.expand_path '../../test_helper', __dir__

# Test class for List Sql Server Firewall Rule Request
class TestListFirewallRules < Minitest::Test
  def setup
    @service = Fog::Sql::AzureRM.new(credentials)
    @sql_manager_client = @service.instance_variable_get(:@sql_mgmt_client)
    @server = @sql_manager_client.servers
  end

  def test_list_sql_server_firewall_rules_success
    list_response = ApiStub::Requests::Sql::FirewallRule.list_firewall_rule_response(@sql_manager_client)
    @server.stub :list_firewall_rules, list_response do
      assert_equal @service.list_firewall_rules('fog-test-rg', 'server-name'), list_response
    end
  end

  def test_list_sql_servers_firewall_rules_failure
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @server.stub :list_firewall_rules, response do
      assert_raises(MsRestAzure::AzureOperationError) { @service.list_firewall_rules('fog-test-rg', 'server-name') }
    end
  end
end
