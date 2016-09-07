require File.expand_path '../../../test_helper', __FILE__

# Test class for Get Subnet Request
class TestGetSubnet < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    @network_client = @service.instance_variable_get(:@network_client)
    @subnets = @network_client.subnets
  end

  def test_get_subnet_success
    mocked_response = ApiStub::Requests::Network::Subnet.create_subnet_response(@network_client)
    @subnets.stub :get, mocked_response do
      assert_equal @service.get_subnet('fog-test-rg', 'fog-test-virtual-network', 'fog-test-subnet'), mocked_response
    end
  end

  def test_get_subnet_exception_failure
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @subnets.stub :get, response do
      assert_raises RuntimeError do
        @service.get_subnet('fog-test-rg', 'fog-test-virtual-network', 'fog-test-subnet')
      end
    end
  end
end
