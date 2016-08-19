require File.expand_path '../../test_helper', __dir__

# Test class for List Subnets Request
class TestListSubnets < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    @client = @service.instance_variable_get(:@network_client)
    @subnets = @client.subnets
  end

  def test_list_subnets_success
    mocked_response = ApiStub::Requests::Network::Subnet.list_subnets_response(@client)
    @subnets.stub :list_as_lazy, mocked_response do
      assert_equal @service.list_subnets('fog-test-rg', 'fog-test-virtual-network'), mocked_response.value
    end
  end

  def test_list_subnets_failure
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @subnets.stub :list_as_lazy, response do
      assert_raises(Fog::AzureRm::OperationError) { @service.list_subnets('fog-test-rg', 'fog-test-virtual-network') }
    end
  end
end
