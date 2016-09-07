require File.expand_path '../../../test_helper', __FILE__

# Test class for Add Security Rules
class TestAddSecurityRules < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    @client = @service.instance_variable_get(:@network_client)
    @network_security_groups = @client.network_security_groups
  end

  def test_add_security_rules_success
    mocked_response = ApiStub::Requests::Network::NetworkSecurityGroup.create_network_security_group_response(@client)
    expected_response_json = ApiStub::Requests::Network::NetworkSecurityGroup.add_security_rules_response(@client)
    security_rule =
      {
        name: 'testRule',
        protocol: 'tcp',
        source_port_range: '22',
        destination_port_range: '22',
        source_address_prefix: '0.0.0.0/0',
        destination_address_prefix: '0.0.0.0/0',
        access: 'Allow',
        priority: '100',
        direction: 'Inbound',
        description: 'This is a test rule'
      }

    @network_security_groups.stub :get, mocked_response do
      @network_security_groups.stub :begin_create_or_update, expected_response_json do
        assert_equal @service.add_security_rules('fog-test-rg', 'fog-test-nsg', [security_rule]), expected_response_json
      end
    end
  end

  def test_add_security_rules_failure
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @network_security_groups.stub :get, response do
      assert_raises MsRestAzure::AzureOperationError do
        @service.add_security_rules('fog-test-rg', 'fog-test-nsg', [])
      end
    end
  end
end
