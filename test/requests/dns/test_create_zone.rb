require File.expand_path '../../test_helper', __dir__

# Test class for Create Zone Request
class TestCreateZone < Minitest::Test
  def setup
    @service = Fog::DNS::AzureRM.new(credentials)
    @zones = @service.zones
    @token_provider = Fog::Credentials::AzureRM.instance_variable_get(:@token_provider)
  end

  def test_create_or_update_zone_success
    response = ApiStub::Requests::DNS::Zone.rest_client_put_method_for_zone_resonse
    @token_provider.stub :get_authentication_header, 'Bearer <some-token>' do
      RestClient.stub :put, response do
        assert_equal @service.create_or_update_zone('fog-test-rg', 'fog-test-zone'), JSON.parse(response)
      end
    end
  end

  def test_create_or_update_zone_failure
    @token_provider.stub :get_authentication_header, 'Bearer <some-token>' do
      assert_raises ArgumentError do
        @service.create_or_update_zone('fog-test-zone')
      end
    end
  end

  def test_create_or_update_zone_exception
    response = -> { fail RestClient::Exception.new("'body': {'error': {'code': 'ResourceNotFound', 'message': 'mocked exception message'}}") }
    @token_provider.stub :get_authentication_header, response do
      assert_raises Exception do
        @service.create_or_update_zone('fog-test-rg', 'fog-test-zone')
      end
    end
  end
end
