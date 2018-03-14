require File.expand_path '../../test_helper', __dir__

# Test class for Get Traffic Manager Endpoint
class TestGetTrafficManagerEndpoint < Minitest::Test
  def setup
    @service = Fog::TrafficManager::AzureRM.new(credentials)
    @traffic_manager_client = @service.instance_variable_get(:@traffic_mgmt_client)
    @end_points = @traffic_manager_client.endpoints
  end

  def test_get_traffic_manager_endpoint_success
    mocked_response = ApiStub::Requests::TrafficManager::TrafficManagerEndPoint.create_traffic_manager_endpoint_response(@traffic_manager_client)
    @end_points.stub :get, mocked_response do
      assert_equal @service.get_traffic_manager_end_point('fog-test-rg', 'fog-test-profile', 'fog-test-endpoint-name', 'fog-test-endpoint-type'), mocked_response
    end
  end

  def test_get_traffic_manager_endpoint_failure
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @end_points.stub :get, response do
      assert_raises(MsRestAzure::AzureOperationError) { @service.get_traffic_manager_end_point('fog-test-rg', 'fog-test-profile', 'wrong-param', 'wrong-param') }
    end
  end
end
