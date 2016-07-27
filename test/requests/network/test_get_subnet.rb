require File.expand_path '../../test_helper', __dir__

# Test class for Get Subnet Request
class TestGetSubnet < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    client = @service.instance_variable_get(:@network_client)
    @subnets = client.subnets
    @promise = Concurrent::Promise.execute do
    end
  end

  def test_get_subnet_success
    mocked_response = ApiStub::Requests::Network::Subnet.create_subnet_response
    expected_response = Azure::ARM::Network::Models::Subnet.serialize_object(mocked_response.body)
    @promise.stub :value!, mocked_response do
      @subnets.stub :get, @promise do
        assert_equal @service.get_subnet('fog-test-rg', 'fog-test-virtual-network', 'fog-test-subnet'), expected_response
      end
    end
  end

  def test_get_subnet_exception_failure
    response = -> { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @promise.stub :value!, response do
      @subnets.stub :get, @promise do
        assert_raises RuntimeError do
          @service.get_subnet('fog-test-rg', 'fog-test-virtual-network', 'fog-test-subnet')
        end
      end
    end
  end
end
