require File.expand_path '../../test_helper', __dir__

# Test class for Detach Route Table from Subnet Request
class TestDetachRouteTableFromSubnet < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    client = @service.instance_variable_get(:@network_client)
    @subnets = client.subnets
    @promise = Concurrent::Promise.execute do
    end
  end

  def test_detach_route_table_from_subnet_success
    mocked_response = ApiStub::Requests::Network::Subnet.create_subnet_response
    expected_response = Azure::ARM::Network::Models::Subnet.serialize_object(mocked_response.body)
    @promise.stub :value!, mocked_response do
      @subnets.stub :create_or_update, @promise do
        assert_equal @service.detach_route_table_from_subnet('fog-test-rg', 'fog-test-subnet', 'fog-test-virtual-network', '10.1.0.0/24', 'nsg-id'), expected_response
      end
    end
  end

  def test_detach_route_table_from_subnet_failure
    response = -> { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @promise.stub :value!, response do
      @subnets.stub :create_or_update, @promise do
        assert_raises RuntimeError do
          @service.detach_route_table_from_subnet('fog-test-rg', 'fog-test-subnet', 'fog-test-virtual-network', '10.1.0.0/24', 'nsg-id')
        end
      end
    end
  end
end
