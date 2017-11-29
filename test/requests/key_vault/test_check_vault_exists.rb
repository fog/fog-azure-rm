require File.expand_path '../../test_helper', __dir__

# Test class for Check Vault Exists Request
class TestCheckVaultExists < Minitest::Test
  def setup
    @service = Fog::KeyVault::AzureRM.new(credentials)
    @key_vault_client = @service.instance_variable_get(:@key_vault_client)
    @vaults = @key_vault_client.vaults
  end

  def test_check_vault_exists_success
    response = ApiStub::Requests::KeyVault::Vault.create_vault_response(@key_vault_client)
    @vaults.stub :get, response do
      assert @service.check_vault_exists('fog-test-rg', 'fog-test-kv')
    end
  end

  def test_check_vault_exists_failure
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, mock_response, 'error' => { 'message' => 'mocked exception', 'code' => 'ResourceNotFound' }) }
    @vaults.stub :get, response do
      assert !@service.check_vault_exists('fog-test-rg', 'fog-test-kv')
    end
  end

  def test_check_vault_exists_exception
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, mock_response, 'error' => { 'message' => 'mocked exception', 'code' => 'ResourceGroupNotFound' }) }
    @vaults.stub :get, response do
      assert !@service.check_vault_exists('fog-test-rg', 'fog-test-kv')
    end
  end
end
