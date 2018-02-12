require File.expand_path '../../test_helper', __dir__

# Test class for Get Network Security Group
class TestGetNetworkSecurityGroup < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    @client = @service.instance_variable_get(:@network_client)
    @network_security_groups = @client.network_security_groups
  end

  def test_get_network_security_group_success
    mocked_response = ApiStub::Requests::Network::NetworkSecurityGroup.create_network_security_group_response(@client)
    @network_security_groups.stub :get, mocked_response do
      assert_equal @service.get_network_security_group('fog-test-rg', 'fog-test-nsg'), mocked_response
    end
  end

  def test_get_network_security_group_failure
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @network_security_groups.stub :get, response do
      assert_raises MsRestAzure::AzureOperationError do
        @service.get_network_security_group('fog-test-rg', 'fog-test-nsg')
      end
    end
  end
end
