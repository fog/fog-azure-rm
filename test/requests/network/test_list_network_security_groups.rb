require File.expand_path '../../test_helper', __dir__

# Test class for List Network Security Group
class TestListNetworkSecurityGroup < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    @client = @service.instance_variable_get(:@network_client)
    @network_security_groups = @client.network_security_groups
  end

  def test_list_network_security_group_success
    mocked_response = ApiStub::Requests::Network::NetworkSecurityGroup.list_network_security_group_response(@client)
    @network_security_groups.stub :list_as_lazy, mocked_response do
      assert_equal @service.list_network_security_groups('fog-test-rg'), mocked_response.value
    end
  end

  def test_list_network_security_group_failure
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @network_security_groups.stub :list_as_lazy, response do
      assert_raises MsRestAzure::AzureOperationError do
        @service.list_network_security_groups('fog-test-rg')
      end
    end
  end
end
