require File.expand_path '../../test_helper', __dir__

# Test class To Attach Resources to NIC
class TestAttachResourceToNIC < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    client = @service.instance_variable_get(:@network_client)
    @network_interfaces = client.network_interfaces
  end

  def test_attach_resources_to_nic_success
    mocked_response = ApiStub::Requests::Network::NetworkInterface.create_network_interface_response
    expected_response = Azure::ARM::Network::Models::NetworkInterface.serialize_object(mocked_response.body)

    get_promise = Concurrent::Promise.execute do
    end
    create_promise = Concurrent::Promise.execute do
    end

    # Attach Subnet
    get_promise.stub :value!, mocked_response do
      @network_interfaces.stub :get, get_promise do
        create_promise.stub :value!, mocked_response do
          @network_interfaces.stub :create_or_update, create_promise do
            assert_equal @service.attach_resource_to_nic('fog-test-rg', 'fog-test-network-interface', 'Subnet', '/subscriptions/{guid}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworks/myvnet1/subnets/mysub1'), expected_response
          end
        end
      end
    end

    # Attach Public-IP
    get_promise.stub :value!, mocked_response do
      @network_interfaces.stub :get, get_promise do
        create_promise.stub :value!, mocked_response do
          @network_interfaces.stub :create_or_update, create_promise do
            assert_equal @service.attach_resource_to_nic('fog-test-rg', 'fog-test-network-interface', 'Public-IP-Address', '/subscriptions/{guid}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/publicIPAddresses/mypip1'), expected_response
          end
        end
      end
    end

    # Attach NSG
    get_promise.stub :value!, mocked_response do
      @network_interfaces.stub :get, get_promise do
        create_promise.stub :value!, mocked_response do
          @network_interfaces.stub :create_or_update, create_promise do
            assert_equal @service.attach_resource_to_nic('fog-test-rg', 'fog-test-network-interface', 'Network-Security-Group', '/subscriptions/{guid}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkSecurityGroups/myNSG1'), expected_response
          end
        end
      end
    end
  end

  def test_attach_resources_to_nic_failure
    response = -> { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception', 'code' => 'ResourceGroupNotFound' }) }
    promise = Concurrent::Promise.execute do
    end

    promise.stub :value!, response do
      @network_interfaces.stub :get, promise do
        assert_raises(RuntimeError) { @service.attach_resource_to_nic('fog-test-rg', 'fog-test-network-interface', 'Network-Security-Group', '/subscriptions/{guid}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkSecurityGroups/myNSG1') }
      end
    end
  end
end
