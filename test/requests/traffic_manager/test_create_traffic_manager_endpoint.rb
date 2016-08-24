require File.expand_path '../../test_helper', __dir__

# Test class for Create Traffic Manager End Point
class TestCreateTrafficManagerEndPoint < Minitest::Test
  def setup
    @service = Fog::TrafficManager::AzureRM.new(credentials)
    @traffic_manager_client = @service.instance_variable_get(:@traffic_mgmt_client)
    @end_points = @traffic_manager_client.endpoints
  end

  def test_create_traffic_manager_endpoint_success
    mocked_response = ApiStub::Requests::TrafficManager::TrafficManagerEndPoint.create_traffic_manager_endpoint_response(@traffic_manager_client)
    @end_points.stub :validate_params, true do
      @end_points.stub :create_or_update, mocked_response do
        assert_equal @service.create_traffic_manager_endpoint('fog-test-rg', 'fog-test-end-point', 'fog-test-profile',
                                                              'external', nil, 'test.com', 10, 5, 'northeurope', nil), mocked_response
      end
    end
  end

  def test_create_traffic_manager_endpoint_failure
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @end_points.stub :validate_params, true do
      @end_points.stub :create_or_update, response do
        assert_raises(RuntimeError) { @service.create_traffic_manager_endpoint('fog-test-rg', 'fog-test-end-point', 'fog-test-profile', 'external', nil, 'test.com', 10, 5, 'northeurope', nil) }
      end
    end
  end
end
