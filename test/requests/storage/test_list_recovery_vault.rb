require File.expand_path '../../test_helper', __dir__

# Test class for List Recovery Vault request
class TestListRecoveryVault < Minitest::Test
  def setup
    @service = Fog::Storage::AzureRM.new(credentials)
    @token_provider = Fog::Credentials::AzureRM.instance_variable_get(:@token_provider)
  end

  def test_list_recovery_vault_success
    response = ApiStub::Requests::Storage::RecoveryVault.get_recovery_vault_response
    @token_provider.stub :get_authentication_header, 'Bearer <some-token>' do
      RestClient.stub :get, response do
        assert_equal @service.list_recovery_vaults('fog-test-rg'), JSON.parse(response)['value']
      end
    end
  end

  def test_list_recovery_vault_argument_error
    @token_provider.stub :get_authentication_header, 'Bearer <some-token>' do
      assert_raises ArgumentError do
        @service.list_recovery_vaults
      end
    end
  end

  def test_list_recovery_vault_exception
    response = -> { fail Exception.new('mocked exception') }
    @token_provider.stub :get_authentication_header, response do
      assert_raises Exception do
        @service.list_recovery_vaults('fog-test-rg')
      end
    end
  end
end
