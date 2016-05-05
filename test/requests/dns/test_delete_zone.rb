require File.expand_path '../../test_helper', __dir__

# Test class for Dellete Zone Request
class TestDeleteZone < Minitest::Test
  def setup
    @service = Fog::DNS::AzureRM.new(credentials)
    @zones = @service.zones
    @token_provider = Fog::Credentials::AzureRM.instance_variable_get(:@token_provider)
  end

  def test_delete_zone_success
    @token_provider.stub :get_authentication_header, 'Bearer <some-token>' do
      RestClient.stub :delete, true do
        assert @service.delete_zone('fog-test-zone', 'fog-test-rg')
      end
    end
  end

  def test_delte_zone_failure
    @token_provider.stub :get_authentication_header, 'Bearer <some-token>' do
      assert_raises ArgumentError do
        @service.delete_zone('fog-test-zone')
      end
    end
  end

  def test_create_zone_exception
    response = -> { fail Exception.new('mocked exception') }
    @token_provider.stub :get_authentication_header, response do
      assert_raises Exception do
        assert @service.delete_zone('fog-test-zone', 'fog-test-rg')
      end
    end
  end
end
