require File.expand_path '../../test_helper', __dir__

# Test class for Create Virtual Network Gateway Request
class TestCreateVirtualNetworkGateway < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    client = @service.instance_variable_get(:@network_client)
    @network_gateways = client.virtual_network_gateways
    @promise = Concurrent::Promise.execute do
    end
  end

  def test_create_virtual_network_gateway_success
    network_gateway_parms = {}
    mocked_response = ApiStub::Requests::Network::VirtualNetworkGateway.create_virtual_network_gateway_response
    expected_response = Azure::ARM::Network::Models::VirtualNetworkGateway.serialize_object(mocked_response.body)
    @promise.stub :value!, mocked_response do
      @network_gateways.stub :create_or_update, @promise do
        assert_equal @service.create_or_update_virtual_network_gateway(network_gateway_parms), expected_response
      end
    end
  end

  def test_create_virtual_network_gateway_argument_error_failure
    response = ApiStub::Requests::Network::VirtualNetworkGateway.create_virtual_network_gateway_response
    @promise.stub :value!, response do
      @network_gateways.stub :create_or_update, @promise do
        assert_raises ArgumentError do
          @service.create_or_update_virtual_network_gateway()
        end
      end
    end
  end

  def test_create_virtual_network_gateway_exception_failure
    network_gateway_parms = {}
    response = -> { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @promise.stub :value!, response do
      @network_gateways.stub :create_or_update, @promise do
        assert_raises RuntimeError do
          @service.create_or_update_virtual_network_gateway(network_gateway_parms)
        end
      end
    end
  end
end
