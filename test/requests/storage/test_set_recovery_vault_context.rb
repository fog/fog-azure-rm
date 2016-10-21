require File.expand_path '../../test_helper', __dir__

# Test class for Set Recovery Vault Context
class TestSetRecoveryVaultContext < Minitest::Test
  def setup
    @service = Fog::Storage::AzureRM.new(credentials)
    @recovery_vaults = @service.recovery_vaults
    @token_provider = Fog::Credentials::AzureRM.instance_variable_get(:@token_provider)
  end

  def test_set_recovery_vault_context_success
    @token_provider.stub :get_authentication_header, 'Bearer <some-token>' do
      RestClient.stub :get, true do
        assert_equal @service.set_recovery_vault_context('fog-test-rg', 'fog-test-vault'), true
      end
    end
  end

  def test_set_recovery_vault_context_argument_error
    @token_provider.stub :get_authentication_header, 'Bearer <some-token>' do
      assert_raises ArgumentError do
        @service.set_recovery_vault_context('fog-test-rg')
      end
    end
  end

  def test_set_recovery_vault_context_exception
    response = -> { fail Exception.new('mocked exception') }
    @token_provider.stub :get_authentication_header, response do
      assert_raises Exception do
        @service.set_recovery_vault_context('fog-test-rg', 'fog-test-vault')
      end
    end
  end
end
