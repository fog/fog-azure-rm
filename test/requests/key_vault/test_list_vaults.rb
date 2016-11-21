require File.expand_path '../../test_helper', __dir__

# Test class for List Vault Request
class TestListVaults < Minitest::Test
  def setup
    @service = Fog::KeyVault::AzureRM.new(credentials)
    @key_vault_client = @service.instance_variable_get(:@key_vault_client)
    @vaults = @key_vault_client.vaults
  end

  def test_list_vaults_success
    mocked_response = ApiStub::Requests::KeyVault::Vault.list_vault_response(@key_vault_client)
    @vaults.stub :list_by_resource_group_as_lazy, mocked_response do
      assert_equal @service.list_vaults('fog-test-rg'), mocked_response.value
    end
  end

  def test_list_vaults_failure
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @vaults.stub :list_by_resource_group_as_lazy, response do
      assert_raises(RuntimeError) { @service.list_vaults('fog-test-rg') }
    end
  end
end
