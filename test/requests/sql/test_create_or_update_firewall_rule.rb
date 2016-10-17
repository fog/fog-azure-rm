require File.expand_path '../../test_helper', __dir__

# Test class for Create Sql Server Firewall Rule
class TestCreateOrUpdateFirewallRule < Minitest::Test
  def setup
    @service = Fog::Sql::AzureRM.new(credentials)
    @token_provider = Fog::Credentials::AzureRM.instance_variable_get(:@token_provider)
  end

  def test_create_or_update_sql_server_firewall_rule_success
    firewall_rule_response = ApiStub::Requests::Sql::FirewallRule.create_firewall_rule_response
    data_hash = ApiStub::Requests::Sql::FirewallRule.firewall_rule_hash
    @token_provider.stub :get_authentication_header, 'Bearer <some-token>' do
      RestClient.stub :put, firewall_rule_response do
        assert_equal @service.create_or_update_firewall_rule(data_hash), JSON.parse(firewall_rule_response)
      end
    end
  end

  def test_create_or_update_sql_server_firewall_rule_failure
    @token_provider.stub :get_authentication_header, 'Bearer <some-token>' do
      assert_raises ArgumentError do
        @service.create_or_update_firewall_rule('test-resource-group', 'test-server-name')
      end
    end
  end
end
