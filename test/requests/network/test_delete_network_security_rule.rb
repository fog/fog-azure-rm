require File.expand_path '../../test_helper', __dir__

# Test class for Delete Network Security Rule
class TestDeleteNetworkSecurityRule < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    client = @service.instance_variable_get(:@network_client)
    @network_security_rules = client.security_rules
  end

  def test_delete_network_security_rule_success
    @network_security_rules.stub :delete, true do
      assert_equal @service.delete_network_security_rule('fog-test-rg', 'fog-test-nsg', 'fog-test-nsr'), true
    end
  end

  def test_delete_network_security_rule_failure
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @network_security_rules.stub :delete, response do
      assert_raises RuntimeError do
        @service.delete_network_security_rule('fog-test-rg', 'fog-test-nsg', 'fog-test-nsr')
      end
    end
  end
end
