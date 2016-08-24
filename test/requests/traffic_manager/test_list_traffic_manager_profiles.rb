require File.expand_path '../../test_helper', __dir__

# Test class for List Traffic Manager Profiles
class TestListTrafficManagerProfiles < Minitest::Test
  def setup
    @service = Fog::TrafficManager::AzureRM.new(credentials)
    @traffic_manager_client = @service.instance_variable_get(:@traffic_mgmt_client)
    @profiles = @traffic_manager_client.profiles
  end

  def test_list_traffic_manager_profiles_success
    mocked_response = ApiStub::Requests::TrafficManager::TrafficManagerProfile.list_traffic_manager_profiles_response(@traffic_manager_client)
    @profiles.stub :list_all_in_resource_group, mocked_response do
      assert_equal @service.list_traffic_manager_profiles('fog-test-rg'), mocked_response.value
    end
  end

  def test_list_traffic_manager_profiles_failure
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @profiles.stub :list_all_in_resource_group, response do
      assert_raises(RuntimeError) { @service.list_traffic_manager_profiles('fog-test-rg') }
    end
  end
end
