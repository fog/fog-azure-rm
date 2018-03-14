require File.expand_path '../../test_helper', __dir__

# Test class for Get Traffic Manager Profile
class TestGetTrafficManagerProfile < Minitest::Test
  def setup
    @service = Fog::TrafficManager::AzureRM.new(credentials)
    @traffic_manager_client = @service.instance_variable_get(:@traffic_mgmt_client)
    @profiles = @traffic_manager_client.profiles
  end

  def test_get_traffic_manager_profile_success
    mocked_response = ApiStub::Requests::TrafficManager::TrafficManagerProfile.create_traffic_manager_profile_response(@traffic_manager_client)
    @profiles.stub :get, mocked_response do
      assert_equal @service.get_traffic_manager_profile('fog-test-rg', 'fog-test-profile'), mocked_response
    end
  end

  def test_get_traffic_manager_profile_failure
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @profiles.stub :get, response do
      assert_raises(MsRestAzure::AzureOperationError) { @service.get_traffic_manager_profile('fog-test-rg', 'fog-test-profile') }
    end
  end
end
