require File.expand_path '../../test_helper', __dir__

# Test class for Delete Traffic Manager End Point
class TestDeleteTrafficManagerEndPoint < Minitest::Test
  def setup
    @service = Fog::TrafficManager::AzureRM.new(credentials)
    @traffic_manager_client = @service.instance_variable_get(:@traffic_mgmt_client)
    @end_points = @traffic_manager_client.endpoints
  end

  def test_delete_traffic_manager_endpoint_success
    @end_points.stub :delete, true do
      assert @service.delete_traffic_manager_endpoint('fog-test-rg', 'fog-test-end-point', 'fog-test-profile', 'external')
    end
  end

  def test_delete_traffic_manager_endpoint_failure
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @end_points.stub :delete, response do
      assert_raises(RuntimeError) { @service.delete_traffic_manager_endpoint('fog-test-rg', 'fog-test-end-point', 'fog-test-profile', 'external') }
    end
  end
end
