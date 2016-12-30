require File.expand_path '../../test_helper', __dir__

# Test class for Check Network Security Group Exists
class TestCheckNetworkSecurityGroupExists < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    @client = @service.instance_variable_get(:@network_client)
    @network_security_groups = @client.network_security_groups
  end

  def test_check_net_sec_group_exists_success
    mocked_response = ApiStub::Requests::Network::NetworkSecurityGroup.create_network_security_group_response(@client)
    @network_security_groups.stub :get, mocked_response do
      assert_equal @service.check_net_sec_group_exists?('fog-test-rg', 'fog-test-nsg'), true
    end
  end

  def test_check_net_sec_group_exists_failure
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception', 'code' => 'ResourceNotFound' }) }
    @network_security_groups.stub :get, response do
      assert !@service.check_net_sec_group_exists?('fog-test-rg', 'fog-test-nsg')
    end
  end

  def test_check_net_sec_group_exists_exception
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception', 'code' => 'ResourceGroupNotFound' }) }
    @network_security_groups.stub :get, response do
      assert_raises(RuntimeError) { @service.check_net_sec_group_exists?('fog-test-rg', 'fog-test-nsg') }
    end
  end
end
