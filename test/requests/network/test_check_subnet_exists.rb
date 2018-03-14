require File.expand_path '../../test_helper', __dir__

# Test class for Check Subnet Exists Request
class TestCheckSubnetExists < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    @network_client = @service.instance_variable_get(:@network_client)
    @subnets = @network_client.subnets
  end

  def test_check_subnet_exists_success
    mocked_response = ApiStub::Requests::Network::Subnet.create_subnet_response(@network_client)
    @subnets.stub :get, mocked_response do
      assert @service.check_subnet_exists('fog-test-rg', 'fog-test-virtual-network', 'fog-test-subnet')
    end
  end

  def test_check_subnet_exists_failure
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, create_mock_response, 'error' => { 'message' => 'mocked exception', 'code' => 'ResourceNotFound' }) }
    @subnets.stub :get, response do
      assert !@service.check_subnet_exists('fog-test-rg', 'fog-test-virtual-network', 'fog-test-subnet')
    end
  end

  def test_check_subnet_resource_group_exists_failure
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, create_mock_response, 'error' => { 'message' => 'mocked exception', 'code' => 'ResourceGroupNotFound' }) }
    @subnets.stub :get, response do
      assert !@service.check_subnet_exists('fog-test-rg', 'fog-test-virtual-network', 'fog-test-subnet')
    end
  end

  def test_check_subnet_exists_exception
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, create_mock_response, 'error' => { 'message' => 'mocked exception', 'code' => 'Exception' }) }
    @subnets.stub :get, response do
      assert_raises(MsRestAzure::AzureOperationError) { @service.check_subnet_exists('fog-test-rg', 'fog-test-virtual-network', 'fog-test-subnet') }
    end
  end
end
