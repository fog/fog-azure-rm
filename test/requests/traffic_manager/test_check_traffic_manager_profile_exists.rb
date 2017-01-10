require File.expand_path '../../test_helper', __dir__

# Test class for Check Traffic Manager Profile Exists
class TestCheckTrafficManagerProfileExists < Minitest::Test
  def setup
    @service = Fog::TrafficManager::AzureRM.new(credentials)
    @traffic_manager_client = @service.instance_variable_get(:@traffic_mgmt_client)
    @profiles = @traffic_manager_client.profiles
  end

  def test_check_traffic_manager_profile_exists_success
    mocked_response = ApiStub::Requests::TrafficManager::TrafficManagerProfile.create_traffic_manager_profile_response(@traffic_manager_client)
    @profiles.stub :get, mocked_response do
      assert @service.check_traffic_manager_profile_exists('fog-test-rg', 'fog-test-profile')
    end
  end

  def test_check_traffic_manager_profile_exists_failure
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception', 'code' => 'ResourceNotFound' }) }
    @profiles.stub :get, response do
      assert !@service.check_traffic_manager_profile_exists('fog-test-rg', 'fog-test-profile')
    end
  end

  def test_check_traffic_manager_profile_exists_exception
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception', 'code' => 'ResourceGroupNotFound' }) }
    @profiles.stub :get, response do
      assert_raises(RuntimeError) { @service.check_traffic_manager_profile_exists('fog-test-rg', 'fog-test-profile') }
    end
  end
end
