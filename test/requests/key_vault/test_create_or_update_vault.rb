require File.expand_path '../../test_helper', __dir__

# Test class for Create Vault Request
class TestCreateOrUpdateVault < Minitest::Test
  def setup
    @service = Fog::KeyVault::AzureRM.new(credentials)
    key_vault_client = @service.instance_variable_get(:@key_vault_client)
    @vaults = key_vault_client.vaults
    @response = ApiStub::Requests::KeyVault::Vault.create_vault_response(key_vault_client)
    @vault_params = ApiStub::Requests::KeyVault::Vault.vault_params
  end

  def test_create_or_update_vault_success
    @vaults.stub :create_or_update, @response do
      assert_equal @service.create_or_update_vault(@vault_params), @response
    end
  end

  def test_create_vault_failure
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @vaults.stub :create_or_update, response do
      assert_raises(RuntimeError) { @service.create_or_update_vault(name: 'fog-test-kv') }
    end
  end
end
