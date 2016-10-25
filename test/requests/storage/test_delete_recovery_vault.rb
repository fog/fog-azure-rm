require File.expand_path '../../test_helper', __dir__

# Test class for Delete Recovery Vault request
class TestDeleteRecoveryVault < Minitest::Test
  def setup
    @service = Fog::Storage::AzureRM.new(credentials)
    @token_provider = Fog::Credentials::AzureRM.instance_variable_get(:@token_provider)
  end

  def test_delete_recovery_vault_success
    @token_provider.stub :get_authentication_header, 'Bearer <some-token>' do
      RestClient.stub :delete, true do
        assert @service.delete_recovery_vault('fog-test-rg', 'fog-test-vault'), true
      end
    end
  end

  def test_delete_recovery_vault_argument_error
    @token_provider.stub :get_authentication_header, 'Bearer <some-token>' do
      assert_raises ArgumentError do
        @service.delete_recovery_vault('fog-test-rg')
      end
    end
  end

  def test_delete_recovery_vault_exception
    response = -> { fail Exception.new('mocked exception') }
    @token_provider.stub :get_authentication_header, response do
      assert_raises Exception do
        assert @service.delete_recovery_vault('fog-test-rg')
      end
    end
  end
end
