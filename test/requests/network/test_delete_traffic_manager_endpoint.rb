require File.expand_path '../../test_helper', __dir__

# Test class for Delete Traffic Manager End Point
class TestDeleteTrafficManagerEndPoint < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    @token_provider = Fog::Credentials::AzureRM.instance_variable_get(:@token_provider)
  end

  def test_delete_traffic_manager_endpoint_success
    @token_provider.stub :get_authentication_header, 'Bearer <some-token>' do
      RestClient.stub :delete, true do
        assert @service.delete_traffic_manager_endpoint('fog-test-rg', 'fog-test-end-point', 'fog-test-profile', 'external')
      end
    end
  end

  def test_delete_traffic_manager_endpoint_failure
    exception = RestClient::Exception.new
    exception.instance_variable_set(:@response, '{"code": "ResourceNotFound", "message": "mocked exception message"}')
    response = -> { fail exception }
    @token_provider.stub :get_authentication_header, response do
      assert_raises RuntimeError do
        @service.delete_traffic_manager_endpoint('fog-test-rg', 'fog-test-end-point', 'fog-test-profile', 'external')
      end
    end
  end
end
