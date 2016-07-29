require File.expand_path '../../test_helper', __dir__

# Test class for Detach Resources from NIC
class TestDetachResourceFromNIC < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    client = @service.instance_variable_get(:@network_client)
    @network_interfaces = client.network_interfaces
  end

  def test_detach_resources_from_nic_success
    mocked_response = ApiStub::Requests::Network::NetworkInterface.create_network_interface_response
    pip_expected_response_json = ApiStub::Requests::Network::NetworkInterface.detach_pip_from_nic_response
    expected_response = Azure::ARM::Network::Models::NetworkInterface.serialize_object(pip_expected_response_json.body)

    get_promise = Concurrent::Promise.execute do
    end
    create_promise = Concurrent::Promise.execute do
    end

    # Detach Public-IP
    get_promise.stub :value!, mocked_response do
      @network_interfaces.stub :get, get_promise do
        create_promise.stub :value!, mocked_response do
          @network_interfaces.stub :create_or_update, create_promise do
            assert_equal @service.detach_resource_from_nic('fog-test-rg', 'fog-test-network-interface', 'Public-IP-Address'), expected_response
          end
        end
      end
    end

    nsg_expected_response_json = ApiStub::Requests::Network::NetworkInterface.detach_nsg_from_nic_response
    expected_response = Azure::ARM::Network::Models::NetworkInterface.serialize_object(nsg_expected_response_json.body)

    # Detach NSG
    get_promise.stub :value!, mocked_response do
      @network_interfaces.stub :get, get_promise do
        create_promise.stub :value!, mocked_response do
          @network_interfaces.stub :create_or_update, create_promise do
            assert_equal @service.detach_resource_from_nic('fog-test-rg', 'fog-test-network-interface', 'Network-Security-Group'), expected_response
          end
        end
      end
    end
  end

  def test_detach_resources_to_nic_failure
    response = -> { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    get_promise = Concurrent::Promise.execute do
    end

    get_promise.stub :value!, response do
      @network_interfaces.stub :get, get_promise do
        assert_raises RuntimeError do
          @service.detach_resource_from_nic('fog-test-rg', 'fog-test-network-interface', 'Network-Security-Group')
        end
      end
    end
  end
end
