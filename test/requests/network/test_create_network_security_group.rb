require File.expand_path '../../test_helper', __dir__

# Test class for Create Network Security Group
class TestCreateNetworkSecurityGroup < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    client = @service.instance_variable_get(:@network_client)
    @network_security_groups = client.network_security_groups
    @promise = Concurrent::Promise.execute do
    end
  end

  def test_create_network_security_group_success
    mocked_response = ApiStub::Requests::Network::NetworkSecurityGroup.create_network_security_group_response
    expected_response = Azure::ARM::Network::Models::NetworkSecurityGroup.serialize_object(mocked_response.body)
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
    @promise.stub :value!, mocked_response do
      @network_security_groups.stub :begin_create_or_update, @promise do
        assert_equal @service.create_network_security_group('fog-test-rg', 'fog-test-nsg', 'West US', [security_rule]), expected_response
      end
    end
  end

  def test_create_network_security_group_failure
    response = -> { fail MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @promise.stub :value!, response do
      @network_security_groups.stub :begin_create_or_update, @promise do
        assert_raises RuntimeError do
          @service.create_network_security_group('fog-test-rg', 'fog-test-nsg', 'West US', [])
        end
      end
    end
  end
end
