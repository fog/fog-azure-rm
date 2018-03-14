require File.expand_path '../../test_helper', __dir__

# Test class for Create Network Security Group
class TestCreateOrUpdateNetworkSecurityGroup < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    @client = @service.instance_variable_get(:@network_client)
    @network_security_groups = @client.network_security_groups
    @tags = { key: 'value' }
  end

  def test_create_or_update_network_security_group_success
    mocked_response = ApiStub::Requests::Network::NetworkSecurityGroup.create_network_security_group_response(@client)
    security_rule = {
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
    @network_security_groups.stub :begin_create_or_update, mocked_response do
      assert_equal @service.create_or_update_network_security_group('fog-test-rg', 'fog-test-nsg', 'West US', [security_rule], @tags), mocked_response
    end
  end

  def test_create_or_update_network_security_group_failure
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @network_security_groups.stub :begin_create_or_update, response do
      assert_raises MsRestAzure::AzureOperationError do
        @service.create_or_update_network_security_group('fog-test-rg', 'fog-test-nsg', 'West US', [], @tags)
      end
    end
  end
end
