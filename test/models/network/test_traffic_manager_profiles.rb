require File.expand_path '../../test_helper', __dir__

# Test class for Traffic Manager Profile Collection
class TestTrafficManagerProfiles < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    @traffic_manager_profiles = Fog::Network::AzureRM::TrafficManagerProfiles.new(resource_group: 'fog-test-rg', service: @service)
    @response = [ApiStub::Models::Network::TrafficManagerProfile.get_traffic_manager_profile_response]
  end

  def test_collection_methods
    methods = [
      :all,
      :get
    ]
    methods.each do |method|
      assert @traffic_manager_profiles.respond_to? method
    end
  end

  def test_collection_attributes
    assert @traffic_manager_profiles.respond_to? :resource_group
  end

  def test_all_method_response
    @service.stub :list_traffic_manager_profiles, @response do
      assert_instance_of Fog::Network::AzureRM::TrafficManagerProfiles, @traffic_manager_profiles.all
      assert @traffic_manager_profiles.all.size >= 1
      @traffic_manager_profiles.all.each do |endpoint|
        assert_instance_of Fog::Network::AzureRM::TrafficManagerProfile, endpoint
      end
    end
  end

  def test_get_method_response
    @service.stub :list_traffic_manager_profiles, @response do
      assert_instance_of Fog::Network::AzureRM::TrafficManagerProfile, @traffic_manager_profiles.get('fog-test-profile')
      assert @traffic_manager_profiles.get('wrong-name').nil?
    end
  end
end
