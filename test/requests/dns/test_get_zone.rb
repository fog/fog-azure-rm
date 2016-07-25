require File.expand_path '../../test_helper', __dir__

# Test class for Get Zone
class TestGetZone < Minitest::Test
  def setup
    @service = Fog::DNS::AzureRM.new(credentials)
    @zones = @service.zones
    @token_provider = Fog::Credentials::AzureRM.instance_variable_get(:@token_provider)
  end

  def test_get_zone_success
    response = ApiStub::Requests::DNS::Zone.rest_client_put_method_for_zone_resonse
    @token_provider.stub :get_authentication_header, 'Bearer <some-token>' do
      RestClient.stub :get, response do
        assert_equal @service.get_zone('fog-test-rg', 'fog-test-zone'), JSON.parse(response)
      end
    end
  end

  def test_get_zone_failure
    @token_provider.stub :get_authentication_header, 'Bearer <some-token>' do
      assert_raises ArgumentError do
        @service.get_zone('fog-test-rg')
      end
    end
  end

  def test_get_zone_exception
    response = -> { fail Exception.new('mocked exception') }
    @token_provider.stub :get_authentication_header, response do
      assert_raises Exception do
        @service.get_zone('fog-test-rg', 'fog-test-zone')
      end
    end
  end

  def test_get_zone_parsing_exception
    @token_provider.stub :get_authentication_header, 'Bearer <some-token>' do
      RestClient.stub :get, '{invalid json}' do
        assert_raises Exception do
          @service..get_zone('fog-test-rg', 'fog-test-zone')
        end
      end
    end
  end
end
