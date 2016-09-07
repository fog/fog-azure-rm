require File.expand_path '../../../test_helper', __FILE__

# Test class for Create Traffic Manager Profile
class TestCreateTrafficManagerProfile < Minitest::Test
  def setup
    @service = Fog::TrafficManager::AzureRM.new(credentials)
    @traffic_manager_client = @service.instance_variable_get(:@traffic_mgmt_client)
    @profiles = @traffic_manager_client.profiles
  end

  def test_create_traffic_manager_profile_success
    mocked_response = ApiStub::Requests::TrafficManager::TrafficManagerProfile.create_traffic_manager_profile_response(@traffic_manager_client)
    @profiles.stub :create_or_update, mocked_response do
      assert_equal @service.create_traffic_manager_profile('fog-test-rg', 'fog-test-profile', 'Performance',
                                                           'fog-test-app', 30, 'http', 80, '/monitorpage.aspx'), mocked_response
    end
  end

  def test_create_traffic_manager_profile_failure
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @profiles.stub :create_or_update, response do
      assert_raises(RuntimeError) { @service.create_traffic_manager_profile('fog-test-rg', 'fog-test-profile', 'Performance', 'fog-test-app', 30, 'http', 80, '/monitorpage.aspx') }
    end
  end
end
