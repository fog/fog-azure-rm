require File.expand_path '../../test_helper', __dir__

# Test class for Attach Network Security Group to Subnet Request
class TestAttachNetworkSecurityGroupToSubnet < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    @client = @service.instance_variable_get(:@network_client)
    @subnets = @client.subnets
  end

  def test_attach_network_security_group_to_subnet_success
    mocked_response = ApiStub::Requests::Network::Subnet.create_subnet_response(@client)
    @subnets.stub :create_or_update, mocked_response do
      assert_equal @service.attach_network_security_group_to_subnet('fog-test-rg', 'fog-test-subnet', 'fog-test-virtual-network', '10.1.0.0/24', 'nsg-id', 'table-id'), mocked_response
    end
  end

  def test_attach_network_security_group_to_subnet_failure
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @subnets.stub :create_or_update, response do
      assert_raises Fog::AzureRm::OperationError do
        @service.attach_network_security_group_to_subnet('fog-test-rg', 'fog-test-subnet', 'fog-test-virtual-network', '10.1.0.0/24', 'nsg-id', 'table-id')
      end
    end
  end
end
