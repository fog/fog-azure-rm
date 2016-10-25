require File.expand_path '../../test_helper', __dir__

# Test class for Create Recovery Vault request
class TestCreateRecoveryVault < Minitest::Test
  def setup
    @service = Fog::Storage::AzureRM.new(credentials)
    @token_provider = Fog::Credentials::AzureRM.instance_variable_get(:@token_provider)
  end

  def test_create_recovery_vault_success
    response = ApiStub::Requests::Storage::RecoveryVault.create_recovery_vault_response
    @token_provider.stub :get_authentication_header, 'Bearer <some-token>' do
      RestClient.stub :put, response do
        assert_equal @service.create_or_update_recovery_vault('fog-test-rg', 'westus', 'fog-test-vault'), JSON.parse(response)
      end
    end
  end

  def test_create_recovery_vault_argument_error
    @token_provider.stub :get_authentication_header, 'Bearer <some-token>' do
      assert_raises ArgumentError do
        @service.create_or_update_recovery_vault('fog-test-rg', 'fog-test-vault')
      end
    end
  end

  def test_create_recovery_vault_exception
    response = -> { fail Exception.new('mocked exception') }
    @token_provider.stub :get_authentication_header, response do
      assert_raises Exception do
        @service.create_or_update_recovery_vault('fog-test-rg', 'westus', 'fog-test-vault')
      end
    end
  end
end
