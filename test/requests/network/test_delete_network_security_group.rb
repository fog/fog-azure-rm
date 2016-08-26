require File.expand_path '../../test_helper', __dir__

# Test class for Delete Network Security Group
class TestDeleteNetworkSecurityGroup < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    client = @service.instance_variable_get(:@network_client)
    @network_security_groups = client.network_security_groups
  end

  def test_delete_network_security_group_success
    @network_security_groups.stub :delete, true do
      assert_equal @service.delete_network_security_group('fog-test-rg', 'fog-test-nsg'), true
    end
  end

  def test_delete_network_security_group_failure
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @network_security_groups.stub :delete, response do
      assert_raises RuntimeError do
        @service.delete_network_security_group('fog-test-rg', 'fog-test-nsg')
      end
    end
  end
end
