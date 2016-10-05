require File.expand_path '../../test_helper', __dir__

# Test class for Traffic Manager Profile Collection
class TestTrafficManagerProfiles < Minitest::Test
  def setup
    @service = Fog::TrafficManager::AzureRM.new(credentials)
    @traffic_manager_profiles = Fog::TrafficManager::AzureRM::TrafficManagerProfiles.new(resource_group: 'fog-test-rg', service: @service)
    traffic_manager_client = @service.instance_variable_get(:@traffic_mgmt_client)
    @profiles_list = [ApiStub::Models::TrafficManager::TrafficManagerProfile.traffic_manager_profile_response(traffic_manager_client)]
    @profile = ApiStub::Models::TrafficManager::TrafficManagerProfile.traffic_manager_profile_response(traffic_manager_client)
  end

  def test_collection_methods
    methods = [
      :all,
      :get
    ]
    methods.each do |method|
      assert_respond_to @traffic_manager_profiles, method
    end
  end

  def test_collection_attributes
    assert_respond_to @traffic_manager_profiles, :resource_group
  end

  def test_all_method_response
    @service.stub :list_traffic_manager_profiles, @profiles_list do
      assert_instance_of Fog::TrafficManager::AzureRM::TrafficManagerProfiles, @traffic_manager_profiles.all
      assert @traffic_manager_profiles.all.size >= 1
      @traffic_manager_profiles.all.each do |endpoint|
        assert_instance_of Fog::TrafficManager::AzureRM::TrafficManagerProfile, endpoint
      end
    end
  end

  def test_get_method_response
    @service.stub :get_traffic_manager_profile, @profile do
      assert_instance_of Fog::TrafficManager::AzureRM::TrafficManagerProfile, @traffic_manager_profiles.get('resource-group-name', 'fog-test-profile-name')
    end
  end
end
