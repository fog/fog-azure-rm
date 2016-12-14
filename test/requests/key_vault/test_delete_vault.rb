require File.expand_path '../../test_helper', __dir__

# Test class for Delete Vault Request
class TestDeleteVault < Minitest::Test
  def setup
    @service = Fog::KeyVault::AzureRM.new(credentials)
    key_vault_client = @service.instance_variable_get(:@key_vault_client)
    @vaults = key_vault_client.vaults
  end

  def test_delete_vault_success
    @vaults.stub :delete, true do
      assert @service.delete_vault('fog-test-rg', 'fog-test-kv'), true
    end
  end

  def test_delete_vault_failure
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @vaults.stub :delete, response do
      assert_raises(RuntimeError) { @service.delete_vault('fog-test-rg', 'fog-test-kv') }
    end
  end
end
