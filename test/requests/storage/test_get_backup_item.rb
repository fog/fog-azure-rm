require File.expand_path '../../test_helper', __dir__

# Test class for Get Backup Item request
class TestGetBackupItem < Minitest::Test
  def setup
    @service = Fog::Storage::AzureRM.new(credentials)
    @recovery_vaults = @service.recovery_vaults
    @token_provider = Fog::Credentials::AzureRM.instance_variable_get(:@token_provider)
  end

  def test_get_backup_item_success
    response = ApiStub::Requests::Storage::RecoveryVault.get_backup_item_response
    @token_provider.stub :get_authentication_header, 'Bearer <some-token>' do
      RestClient.stub :get, response do
        assert_equal @service.get_backup_item('fog-test-rg', 'fog-test-vault'), JSON.parse(response)['value']
      end
    end
  end

  def test_get_backup_item_argument_error
    @token_provider.stub :get_authentication_header, 'Bearer <some-token>' do
      assert_raises ArgumentError do
        @service.get_backup_item('fog-test-rg')
      end
    end
  end

  def test_get_backup_item_exception
    response = -> { fail Exception.new('mocked exception') }
    @token_provider.stub :get_authentication_header, response do
      assert_raises Exception do
        @service.get_backup_item('fog-test-rg', 'fog-test-vault')
      end
    end
  end
end
