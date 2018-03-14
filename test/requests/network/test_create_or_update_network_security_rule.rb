require File.expand_path '../../test_helper', __dir__

# Test class for Create Network Security Rule
class TestCreateOrUpdateNetworkSecurityRule < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    @client = @service.instance_variable_get(:@network_client)
    @network_security_rules = @client.security_rules
  end

  def test_create_or_update_network_security_rule_success
    mocked_response = ApiStub::Requests::Network::NetworkSecurityRule.create_network_security_rule_response(@client)
    security_rule_params = ApiStub::Requests::Network::NetworkSecurityRule.network_security_rule_paramteres_hash
    @network_security_rules.stub :create_or_update, mocked_response do
      assert_equal @service.create_or_update_network_security_rule(security_rule_params), mocked_response
    end
  end

  def test_create_or_update_network_security_rule_failure
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    security_rule_params = ApiStub::Requests::Network::NetworkSecurityRule.network_security_rule_paramteres_hash
    @network_security_rules.stub :create_or_update, response do
      assert_raises MsRestAzure::AzureOperationError do
        @service.create_or_update_network_security_rule(security_rule_params)
      end
    end
  end
end
