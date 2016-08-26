require File.expand_path '../../test_helper', __dir__

# Test class To Attach Resources to NIC
class TestAttachResourceToNIC < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    @network_client = @service.instance_variable_get(:@network_client)
    @network_interfaces = @network_client.network_interfaces
  end

  def test_attach_resources_to_nic_success
    mocked_response = ApiStub::Requests::Network::NetworkInterface.create_network_interface_response(@network_client)

    # Attach Subnet
    @network_interfaces.stub :get, mocked_response do
      @network_interfaces.stub :create_or_update, mocked_response do
        assert_equal @service.attach_resource_to_nic('fog-test-rg', 'fog-test-network-interface', 'Subnet', '/subscriptions/{guid}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworks/myvnet1/subnets/mysub1'), mocked_response
      end
    end

    # Attach Public-IP
    @network_interfaces.stub :get, mocked_response do
      @network_interfaces.stub :create_or_update, mocked_response do
        assert_equal @service.attach_resource_to_nic('fog-test-rg', 'fog-test-network-interface', 'Public-IP-Address', '/subscriptions/{guid}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/publicIPAddresses/mypip1'), mocked_response
      end
    end

    # Attach NSG
    @network_interfaces.stub :get, mocked_response do
      @network_interfaces.stub :create_or_update, mocked_response do
        assert_equal @service.attach_resource_to_nic('fog-test-rg', 'fog-test-network-interface', 'Network-Security-Group', '/subscriptions/{guid}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkSecurityGroups/myNSG1'), mocked_response
      end
    end
  end

  def test_attach_resources_to_nic_failure
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception', 'code' => 'ResourceGroupNotFound' }) }

    @network_interfaces.stub :get, response do
      assert_raises(RuntimeError) { @service.attach_resource_to_nic('fog-test-rg', 'fog-test-network-interface', 'Network-Security-Group', '/subscriptions/{guid}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkSecurityGroups/myNSG1') }
    end
  end
end
