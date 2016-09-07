require File.expand_path '../../../test_helper', __FILE__

# Test class for Delete Traffic Manager Profile
class TestDeleteTrafficManagerProfile < Minitest::Test
  def setup
    @service = Fog::TrafficManager::AzureRM.new(credentials)
    @traffic_manager_client = @service.instance_variable_get(:@traffic_mgmt_client)
    @profiles = @traffic_manager_client.profiles
  end

  def test_delete_traffic_manager_profile_success
    @profiles.stub :delete, true do
      assert @service.delete_traffic_manager_profile('fog-test-rg', 'fog-test-profile')
    end
  end

  def test_delete_traffic_manager_profile_failure
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @profiles.stub :delete, response do
      assert_raises(RuntimeError) { @service.delete_traffic_manager_profile('fog-test-rg', 'fog-test-profile') }
    end
  end
end
