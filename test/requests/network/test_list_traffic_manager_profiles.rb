require File.expand_path '../../test_helper', __dir__

# Test class for List Traffic Manager Profiles
class TestListTrafficManagerProfiles < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    @token_provider = Fog::Credentials::AzureRM.instance_variable_get(:@token_provider)
  end

  def test_list_traffic_manager_profiles_success
    response = ApiStub::Requests::Network::TrafficManagerProfile.list_traffic_manager_profiles_response
    @token_provider.stub :get_authentication_header, 'Bearer <some-token>' do
      RestClient.stub :get, response do
        assert @service.list_traffic_manager_profiles('fog-test-rg')
      end
    end
  end

  def test_list_traffic_manager_profiles_failure
    exception = RestClient::Exception.new
    exception.instance_variable_set(:@response, '{"code": "ResourceNotFound", "message": "mocked exception message"}')
    response = -> { raise exception }
    @token_provider.stub :get_authentication_header, response do
      assert_raises RuntimeError do
        @service.list_traffic_manager_profiles('fog-test-rg')
      end
    end
  end
end
