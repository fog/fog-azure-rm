require File.expand_path '../../test_helper', __dir__

# Test class for Get Network Security Rule
class TestGetNetworkSecurityRule < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    @client = @service.instance_variable_get(:@network_client)
    @network_security_rules = @client.security_rules
  end

  def test_get_network_security_rule_success
    mocked_response = ApiStub::Requests::Network::NetworkSecurityRule.create_network_security_rule_response(@client)
    @network_security_rules.stub :get, mocked_response do
      assert_equal @service.get_network_security_rule('fog-test-rg', 'fog-test-nsg', 'fog-test-nsr'), mocked_response
    end
  end

  def test_get_network_security_rule_failure
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @network_security_rules.stub :get, response do
      assert_raises MsRestAzure::AzureOperationError do
        @service.get_network_security_rule('fog-test-rg', 'fog-test-nsg', 'fog-test-nsr')
      end
    end
  end
end
