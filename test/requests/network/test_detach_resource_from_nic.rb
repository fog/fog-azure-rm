require File.expand_path '../../test_helper', __dir__

# Test class for Detach Resources from NIC
class TestDetachResourceFromNIC < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    @network_client = @service.instance_variable_get(:@network_client)
    @network_interfaces = @network_client.network_interfaces
  end

  def test_detach_resources_from_nic_success
    mocked_response = ApiStub::Requests::Network::NetworkInterface.create_network_interface_response(@network_client)
    pip_expected_response = ApiStub::Requests::Network::NetworkInterface.detach_pip_from_nic_response(@network_client)

    # Detach Public-IP
    @network_interfaces.stub :get, mocked_response do
      @network_interfaces.stub :create_or_update, pip_expected_response do
        assert_equal @service.detach_resource_from_nic('fog-test-rg', 'fog-test-network-interface', 'Public-IP-Address'), pip_expected_response
      end
    end

    nsg_expected_response = ApiStub::Requests::Network::NetworkInterface.detach_nsg_from_nic_response(@network_client)

    # Detach NSG
    @network_interfaces.stub :get, mocked_response do
      @network_interfaces.stub :create_or_update, nsg_expected_response do
        assert_equal @service.detach_resource_from_nic('fog-test-rg', 'fog-test-network-interface', 'Network-Security-Group'), nsg_expected_response
      end
    end
  end

  def test_detach_resources_to_nic_failure
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }

    @network_interfaces.stub :get, response do
      assert_raises RuntimeError do
        @service.detach_resource_from_nic('fog-test-rg', 'fog-test-network-interface', 'Network-Security-Group')
      end
    end
  end
end
