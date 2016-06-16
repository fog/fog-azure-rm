require File.expand_path '../../test_helper', __dir__

# Test class for Create Network Interface Request
class TestCreateNetworkInterface < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    client = @service.instance_variable_get(:@network_client)
    @network_interfaces = client.network_interfaces
    @promise = Concurrent::Promise.execute do
    end
  end

  def test_create_network_interface_success
    mocked_response = ApiStub::Requests::Network::NetworkInterface.create_network_interface_response
    expected_response = Azure::ARM::Network::Models::NetworkInterface.serialize_object(mocked_response.body)
    @promise.stub :value!, mocked_response do
      @network_interfaces.stub :create_or_update, @promise do
        assert_equal @service.create_network_interface('fog-test-rg', 'fog-test-network-interface', 'West US', 'fog-test-subnet-id', 'fog-test-ip-address-id', 'fog-test-ip-configuration', 'Dynamic'), expected_response
      end
    end
  end

  def test_create_network_interface_without_public_ip_success
    mocked_response = ApiStub::Requests::Network::NetworkInterface.create_network_interface_response
    expected_response = Azure::ARM::Network::Models::NetworkInterface.serialize_object(mocked_response.body)
    @promise.stub :value!, mocked_response do
      @network_interfaces.stub :create_or_update, @promise do
        assert_equal @service.create_network_interface('fog-test-rg', 'fog-test-network-interface', 'West US', 'fog-test-subnet-id', nil, 'fog-test-ip-configuration', 'Dynamic'), expected_response
      end
    end
  end

  def test_create_network_interface_argument_error_failure
    response = ApiStub::Requests::Network::NetworkInterface.create_network_interface_response
    @promise.stub :value!, response do
      @network_interfaces.stub :create_or_update, @promise do
        assert_raises ArgumentError do
          @service.create_network_interface('fog-test-rg', 'fog-test-network-interface', 'West US', 'fog-test-subnet-id', 'fog-test-ip-address-id', 'fog-test-ip-configuration')
        end
      end
    end
  end

  def test_create_network_interface_exception_failure
    response = -> { fail MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @promise.stub :value!, response do
      @network_interfaces.stub :create_or_update, @promise do
        assert_raises RuntimeError do
          @service.create_network_interface('fog-test-rg', 'fog-test-network-interface', 'West US', 'fog-test-subnet-id', 'fog-test-ip-address-id', 'fog-test-ip-configuration', 'Dynamic')
        end
      end
    end
  end
end
