require File.expand_path '../../test_helper', __dir__

# Test class for Remove Security Rule
class TestRemoveSecurityRule < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    @client = @service.instance_variable_get(:@network_client)
    @network_security_groups = @client.network_security_groups
  end

  def test_remove_security_rule_success
    mocked_response = ApiStub::Requests::Network::NetworkSecurityGroup.add_security_rules_response(@client)
    expected_response_json = ApiStub::Requests::Network::NetworkSecurityGroup.create_network_security_group_response(@client)
    @network_security_groups.stub :get, mocked_response do
      @network_security_groups.stub :begin_create_or_update, expected_response_json do
        assert_equal @service.remove_security_rule('fog-test-rg', 'fog-test-nsg', 'testRule'), expected_response_json
      end
    end
  end

  def test_remove_security_rule_failure
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @network_security_groups.stub :get, response do
      assert_raises MsRestAzure::AzureOperationError do
        @service.remove_security_rule('fog-test-rg', 'fog-test-nsg', 'testRule')
      end
    end
  end
end
