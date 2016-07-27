require File.expand_path '../../test_helper', __dir__

# Test class for Create Traffic Manager End Point
class TestCreateTrafficManagerEndPoint < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    @token_provider = Fog::Credentials::AzureRM.instance_variable_get(:@token_provider)
  end

  def test_create_traffic_manager_endpoint_success
    response = ApiStub::Requests::Network::TrafficManagerEndPoint.create_traffic_manager_endpoint_response
    @token_provider.stub :get_authentication_header, 'Bearer <some-token>' do
      RestClient.stub :put, response do
        assert_equal @service.create_traffic_manager_endpoint('fog-test-rg', 'fog-test-end-point', 'fog-test-profile',
                                                              'external', nil, 'test.com', 10, 5, 'northeurope', nil),
                     JSON.parse(response)
      end
    end
  end

  def test_create_traffic_manager_endpoint_failure
    exception = RestClient::Exception.new
    exception.instance_variable_set(:@response, '{"code": "ResourceNotFound", "message": "mocked exception message"}')
    response = -> { raise exception }
    @token_provider.stub :get_authentication_header, response do
      assert_raises RuntimeError do
        @service.create_traffic_manager_endpoint('fog-test-rg', 'fog-test-end-point', 'fog-test-profile',
                                                 'external', nil, 'test.com', 10, 5, 'northeurope', nil)
      end
    end
  end
end
