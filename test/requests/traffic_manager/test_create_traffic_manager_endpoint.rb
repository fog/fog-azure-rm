require File.expand_path '../../test_helper', __dir__

# Test class for Create Traffic Manager End Point
class TestCreateTrafficManagerEndPoint < Minitest::Test
  def setup
    @service = Fog::TrafficManager::AzureRM.new(credentials)
    @traffic_manager_client = @service.instance_variable_get(:@traffic_mgmt_client)
    @end_points = @traffic_manager_client.endpoints
    @endpoint_hash = ApiStub::Requests::TrafficManager::TrafficManagerEndPoint.endpoint_hash
  end

  def test_create_traffic_manager_endpoint_success
    mocked_response = ApiStub::Requests::TrafficManager::TrafficManagerEndPoint.create_traffic_manager_endpoint_response(@traffic_manager_client)
    @end_points.stub :create_or_update, mocked_response do
      assert_equal @service.create_traffic_manager_endpoint(@endpoint_hash), mocked_response
    end
  end

  def test_create_traffic_manager_endpoint_failure
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @end_points.stub :create_or_update, response do
      assert_raises(RuntimeError) { @service.create_traffic_manager_endpoint(@endpoint_hash) }
    end
  end
end
