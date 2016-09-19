require File.expand_path '../../test_helper', __dir__

# Test class for List Network Security Rule
class TestListNetworkSecurityRule < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    @client = @service.instance_variable_get(:@network_client)
    @network_security_rules = @client.security_rules
  end

  def test_list_network_security_rule_success
    mocked_response = ApiStub::Requests::Network::NetworkSecurityRule.list_network_security_rules(@client)
    @network_security_rules.stub :list_as_lazy, mocked_response do
      assert_equal @service.list_network_security_rules('fog-test-rg', 'fog-test-nsg'), mocked_response.value
    end
  end

  def test_list_network_security_rule_failure
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @network_security_rules.stub :list_as_lazy, response do
      assert_raises RuntimeError do
        @service.list_network_security_rules('fog-test-rg', 'fog-test-nsg')
      end
    end
  end
end
