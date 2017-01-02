require File.expand_path '../../test_helper', __dir__

# Test class for Create Sql Server Firewall Rule
class TestCreateOrUpdateFirewallRule < Minitest::Test
  def setup
    @service = Fog::Sql::AzureRM.new(credentials)
    @sql_manager_client = @service.instance_variable_get(:@sql_mgmt_client)
    @firewall_rule = @sql_manager_client.servers
    @data_hash = ApiStub::Requests::Sql::FirewallRule.firewall_rule_hash
  end

  def test_create_or_update_sql_server_firewall_rule_success
    firewall_rule_response = ApiStub::Requests::Sql::FirewallRule.create_firewall_rule_response(@sql_manager_client)
    @firewall_rule.stub :create_or_update_firewall_rule, firewall_rule_response do
      assert_equal @service.create_or_update_firewall_rule(@data_hash), firewall_rule_response
    end
  end

  def test_create_or_update_sql_server_firewall_rule_failure
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @firewall_rule.stub :create_or_update_firewall_rule, response do
      assert_raises(RuntimeError) { @service.create_or_update_firewall_rule(@data_hash) }
    end
  end
end
