require File.expand_path '../../test_helper', __dir__

# Test class for Delete Sql Server Firewall Rule
class TestDeleteFirewallRule < Minitest::Test
  def setup
    @service = Fog::Sql::AzureRM.new(credentials)
    @token_provider = Fog::Credentials::AzureRM.instance_variable_get(:@token_provider)
  end

  def test_delete_sql_server_firewall_rule_success
    @token_provider.stub :get_authentication_header, 'Bearer <some-token>' do
      RestClient.stub :delete, true do
        assert @service.delete_firewall_rule('fog-test-rg', 'fog-test-server-name', 'rule-name')
      end
    end
  end

  def test_delete_sql_server_firewall_rule_failure
    @token_provider.stub :get_authentication_header, 'Bearer <some-token>' do
      assert_raises ArgumentError do
        @service.delete_firewall_rule('fog-test-name')
      end
    end
  end

  def test_delete_sql_server_firewall_rule_exception
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @token_provider.stub :get_authentication_header, response do
      assert_raises Exception do
        assert @service.delete_firewall_rule('fog-test-rg', 'fog-test-server-name', 'rule-name')
      end
    end
  end
end
