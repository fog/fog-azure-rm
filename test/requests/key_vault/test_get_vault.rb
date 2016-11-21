require File.expand_path '../../test_helper', __dir__

# Test class for Get Vault Request
class TestGetVault < Minitest::Test
  def setup
    @service = Fog::KeyVault::AzureRM.new(credentials)
    @key_vault_client = @service.instance_variable_get(:@key_vault_client)
    @vaults = @key_vault_client.vaults
  end

  def test_get_vault_success
    response = ApiStub::Requests::KeyVault::Vault.create_vault_response(@key_vault_client)
    @vaults.stub :get, response do
      assert_equal @service.get_vault('fog-test-rg', 'fog-test-kv'), response
    end
  end

  def test_get_vault_failure
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @vaults.stub :get, response do
      assert_raises(RuntimeError) { @service.get_vault('fog-test-rg', 'fog-test-kv') }
    end
  end
end
