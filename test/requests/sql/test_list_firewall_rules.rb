require File.expand_path '../../test_helper', __dir__

# Test class for List Sql Server Firewall Rule Request
class TestListFirewallRules < Minitest::Test
  def setup
    @service = Fog::Sql::AzureRM.new(credentials)
    @token_provider = Fog::Credentials::AzureRM.instance_variable_get(:@token_provider)
  end

  def test_list_sql_server_firewall_rules_success
    list_response = ApiStub::Requests::Sql::FirewallRule.list_firewall_rule_response
    @token_provider.stub :get_authentication_header, 'Bearer <some-token>' do
      RestClient.stub :get, list_response do
        assert_equal @service.list_firewall_rules('fog-test-rg', 'server-name'), JSON.parse(list_response)['value']
      end
    end
  end

  def test_list_sql_servers_firewall_rules_failure
    @token_provider.stub :get_authentication_header, 'Bearer <some-token>' do
      assert_raises ArgumentError do
        @service.list_firewall_rules('fog-test-rg')
      end
    end
  end

  def test_list_sql_servers_firewall_rules_exception
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @token_provider.stub :get_authentication_header, response do
      assert_raises Exception do
        @service.list_firewall_rules('fog-test-rg', 'server-name')
      end
    end
  end
end
