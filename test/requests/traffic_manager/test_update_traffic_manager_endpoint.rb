require File.expand_path '../../test_helper', __dir__

# Test class for Update Traffic Manager End Point
class TestUpdateTrafficManagerEndPoint < Minitest::Test
  def setup
    @service = Fog::TrafficManager::AzureRM.new(credentials)
    @traffic_manager_client = @service.instance_variable_get(:@traffic_mgmt_client)
    @end_points = @traffic_manager_client.endpoints
    @mocked_response = ApiStub::Requests::TrafficManager::TrafficManagerEndPoint.create_traffic_manager_endpoint_response(@traffic_manager_client)
  end

  def test_update_traffic_manager_profile_success
    @endpoint_hash = ApiStub::Requests::TrafficManager::TrafficManagerEndPoint.endpoint_hash
    @end_points.stub :create_or_update, @mocked_response do
      assert_equal @service.create_or_update_traffic_manager_endpoint(@endpoint_hash), @mocked_response
    end
  end

  def test_update_traffic_manager_profile_exception_failure
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @end_points.stub :create_or_update, response do
      assert_raises RuntimeError do
        @service.create_or_update_traffic_manager_endpoint(resource_group: 'resource-group', name: 'name', traffic_manager_profile_name: 'traffic_manager_profile_name', type: 'type')
      end
    end
  end
end
