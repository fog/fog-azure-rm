require File.expand_path '../../test_helper', __dir__

# Test class for Create Network Interface Request
class TestCreateNetworkInterface < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    @network_client = @service.instance_variable_get(:@network_client)
    @network_interfaces = @network_client.network_interfaces
    @tags = { key: 'value' }
  end

  def test_create_network_interface_success
    mocked_response = ApiStub::Requests::Network::NetworkInterface.create_network_interface_response(@network_client)
    @network_interfaces.stub :create_or_update, mocked_response do
      assert_equal @service.create_or_update_network_interface('fog-test-rg', 'fog-test-network-interface', 'West US', 'fog-test-subnet-id', 'fog-test-ip-address-id', 'fog-test-nsg-id', 'fog-test-ip-configuration', 'Dynamic', '10.0.0.8', ['id-1', 'id-2'], ['id-1', 'id-2'], @tags), mocked_response
    end

    # Async
    @network_interfaces.stub :create_or_update_async, mocked_response do
      assert_equal @service.create_or_update_network_interface('fog-test-rg', 'fog-test-network-interface', 'West US', 'fog-test-subnet-id', 'fog-test-ip-address-id', 'fog-test-nsg-id', 'fog-test-ip-configuration', 'Dynamic', '10.0.0.8', ['id-1', 'id-2'], ['id-1', 'id-2'], @tags, false, true), mocked_response
    end
  end

  def test_create_network_interface_without_public_ip_success
    mocked_response = ApiStub::Requests::Network::NetworkInterface.create_network_interface_response(@network_client)
    @network_interfaces.stub :create_or_update, mocked_response do
      assert_equal @service.create_or_update_network_interface('fog-test-rg', 'fog-test-network-interface', 'West US', 'fog-test-subnet-id', nil, 'fog-test-nsg-id', 'fog-test-ip-configuration', 'Dynamic', '10.0.0.8', ['id-1', 'id-2'], ['id-1', 'id-2'], @tags), mocked_response
    end

    # Async
    @network_interfaces.stub :create_or_update_async, mocked_response do
      assert_equal @service.create_or_update_network_interface('fog-test-rg', 'fog-test-network-interface', 'West US', 'fog-test-subnet-id', nil, 'fog-test-nsg-id', 'fog-test-ip-configuration', 'Dynamic', '10.0.0.8', ['id-1', 'id-2'], ['id-1', 'id-2'], @tags, false, true), mocked_response
    end
  end

  def test_create_network_interface_argument_error_failure
    response = ApiStub::Requests::Network::NetworkInterface.create_network_interface_response(@network_client)
    @network_interfaces.stub :create_or_update, response do
      assert_raises ArgumentError do
        @service.create_or_update_network_interface('fog-test-rg', 'fog-test-network-interface', 'West US', 'fog-test-subnet-id', 'fog-test-ip-address-id', 'fog-test-nsg-id', 'fog-test-ip-configuration', ['id-1', 'id-2'], ['id-1', 'id-2'])
      end
    end

    # Async
    @network_interfaces.stub :create_or_update_async, response do
      assert_raises ArgumentError do
        @service.create_or_update_network_interface('fog-test-rg', 'fog-test-network-interface', 'West US', 'fog-test-subnet-id', 'fog-test-ip-address-id', 'fog-test-nsg-id', 'fog-test-ip-configuration', ['id-1', 'id-2'], ['id-1', 'id-2'], false, true)
      end
    end
  end

  def test_create_network_interface_exception_failure
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @network_interfaces.stub :create_or_update, response do
      assert_raises MsRestAzure::AzureOperationError do
        @service.create_or_update_network_interface('fog-test-rg', 'fog-test-network-interface', 'West US', 'fog-test-subnet-id', 'fog-test-ip-address-id', 'fog-test-nsg-id', 'fog-test-ip-configuration', 'Dynamic', '10.0.0.8', ['id-1', 'id-2'], ['id-1', 'id-2'], @tags)
      end
    end

    # Async
    @network_interfaces.stub :create_or_update_async, response do
      assert_raises MsRestAzure::AzureOperationError do
        @service.create_or_update_network_interface('fog-test-rg', 'fog-test-network-interface', 'West US', 'fog-test-subnet-id', 'fog-test-ip-address-id', 'fog-test-nsg-id', 'fog-test-ip-configuration', 'Dynamic', '10.0.0.8', ['id-1', 'id-2'], ['id-1', 'id-2'], @tags, false, true)
      end
    end
  end
end
