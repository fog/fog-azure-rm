require File.expand_path '../../test_helper', __dir__

# Test class for Get Sql Server Firewall Rule
class TestGetFirewallRule < Minitest::Test
  def setup
    @service = Fog::Sql::AzureRM.new(credentials)
    @sql_manager_client = @service.instance_variable_get(:@sql_mgmt_client)
    @servers = @sql_manager_client.servers
  end

  def test_get_sql_server_firewall_rule_success
    create_response = ApiStub::Requests::Sql::FirewallRule.create_firewall_rule_response(@sql_manager_client)
    @servers.stub :get_firewall_rule, create_response do
      assert_equal @service.get_firewall_rule('fog-test-rg', 'fog-test-server-name', 'rule-name'), create_response
    end
  end

  def test_get_sql_server_firewall_rule_failure
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @servers.stub :get_firewall_rule, response do
      assert_raises(MsRestAzure::AzureOperationError) { @service.get_firewall_rule('fog-test-rg', 'fog-test-server-name', 'rule-name') }
    end
  end
end
