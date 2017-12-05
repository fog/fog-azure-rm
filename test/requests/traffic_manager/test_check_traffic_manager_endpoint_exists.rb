require File.expand_path '../../test_helper', __dir__

# Test class for Check Traffic Manager Endpoint Exists
class TestCheckTrafficManagerEndpointExists < Minitest::Test
  def setup
    @service = Fog::TrafficManager::AzureRM.new(credentials)
    @traffic_manager_client = @service.instance_variable_get(:@traffic_mgmt_client)
    @end_points = @traffic_manager_client.endpoints
  end

  def test_check_traffic_manager_endpoint_exists_success
    mocked_response = ApiStub::Requests::TrafficManager::TrafficManagerEndPoint.create_traffic_manager_endpoint_response(@traffic_manager_client)
    @end_points.stub :get, mocked_response do
      assert @service.check_traffic_manager_endpoint_exists('fog-test-rg', 'fog-test-profile', 'fog-test-endpoint-name', 'fog-test-endpoint-type')
    end
  end

  def test_check_traffic_manager_endpoint_exists_failure
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, create_mock_response, 'code' => 'NotFound') }
    @end_points.stub :get, response do
      assert !@service.check_traffic_manager_endpoint_exists('fog-test-rg', 'fog-test-profile', 'fog-test-endpoint-name', 'fog-test-endpoint-type')
    end
  end

  def test_check_traffic_manager_endpoint_exists_exception
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, create_mock_response, 'error' => { 'message' => 'mocked exception', 'code' => 'ResourceGroupNotFound' }) }
    @end_points.stub :get, response do
      assert !@service.check_traffic_manager_endpoint_exists('fog-test-rg', 'fog-test-profile', 'fog-test-endpoint-name', 'fog-test-endpoint-type')
    end
  end
end
