require File.expand_path '../../test_helper', __dir__

# Test class for Check Network Security Rule Exists
class TestCheckNetworkSecurityRuleExists < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    @client = @service.instance_variable_get(:@network_client)
    @network_security_rules = @client.security_rules
  end

  def test_check_net_sec_rule_exists_success
    mocked_response = ApiStub::Requests::Network::NetworkSecurityRule.create_network_security_rule_response(@client)
    @network_security_rules.stub :get, mocked_response do
      assert @service.check_net_sec_rule_exists?('fog-test-rg', 'fog-test-nsg', 'fog-test-nsr')
    end
  end

  def test_check_net_sec_rule_exists_failure
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception', 'code' => 'ResourceNotFound' }) }
    @network_security_rules.stub :get, response do
      assert !@service.check_net_sec_rule_exists?('fog-test-rg', 'fog-test-nsg', 'fog-test-nsr')
    end
  end

  def test_check_net_sec_rule_exists_exception
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception', 'code' => 'ResourceGroupNotFound' }) }
    @network_security_rules.stub :get, response do
      assert_raises(RuntimeError) { @service.check_net_sec_rule_exists?('fog-test-rg', 'fog-test-nsg', 'fog-test-nsr') }
    end
  end
end
