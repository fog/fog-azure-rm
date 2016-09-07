require File.expand_path '../../../test_helper', __FILE__

# Test class for Check for Zone Request
class TestCheckForZone < Minitest::Test
  def setup
    @service = Fog::DNS::AzureRM.new(credentials)
    @zones = @service.zones
    @token_provider = Fog::Credentials::AzureRM.instance_variable_get(:@token_provider)
  end

  def test_check_for_zone_success
    response = ApiStub::Requests::DNS::Zone.zone_response
    @token_provider.stub :get_authentication_header, 'Bearer <some-token>' do
      RestClient.stub :get, response do
        assert @service.check_for_zone('fog-test-rg', 'fog-test-zone')
      end
    end
  end

  def test_check_for_zone_success_if_not_found
    response = -> { fail RestClient::Exception.new('{"error": {"code": "ResourceNotFound"}}') }
    @token_provider.stub :get_authentication_header, response do
      assert !@service.check_for_zone('fog-test-rg', 'fog-test-zone')
    end
  end

  def test_check_for_zone_success_if_not_found_failure
    response = -> { fail RestClient::Exception.new('{"error": {"code": "InvalidCode"}}') }
    @token_provider.stub :get_authentication_header, response do
      assert_raises Exception do
        @service.check_for_zone('fog-test-rg', 'fog-test-zone')
      end
    end
  end

  def test_check_for_zone_failure
    @token_provider.stub :get_authentication_header, 'Bearer <some-token>' do
      assert_raises ArgumentError do
        @service.check_for_zone('fog-test-rg')
      end
    end
  end

  def test_check_for_zone_exception
    response = -> { fail Exception.new('mocked exception') }
    @token_provider.stub :get_authentication_header, response do
      assert_raises Exception do
        @service.check_for_zone('fog-test-rg', 'fog-test-zone')
      end
    end
  end
end
