require File.expand_path '../../test_helper', __dir__

# Test class for Vaults Collection
class TestVaults < Minitest::Test
  def setup
    @service = Fog::KeyVault::AzureRM.new(credentials)
    @key_vault_client = @service.instance_variable_get(:@key_vault_client)
    @vaults = Fog::KeyVault::AzureRM::Vaults.new(resource_group: 'fog-test-rg', service: @service)
    @response = ApiStub::Models::KeyVault::Vault.create_vault_response(@key_vault_client)
  end

  def test_collection_methods
    methods = [
      :all,
      :get,
      :check_vault_exists
    ]
    methods.each do |method|
      assert_respond_to @vaults, method
    end
  end

  def test_collection_attributes
    assert_respond_to @vaults, :resource_group
  end

  def test_all_method_response
    response = [@response]
    @service.stub :list_vaults, response do
      assert_instance_of Fog::KeyVault::AzureRM::Vaults, @vaults.all
      assert @vaults.all.size >= 1
      @vaults.all.each do |vault|
        assert_instance_of Fog::KeyVault::AzureRM::Vault, vault
      end
    end
  end

  def test_get_method_response
    @service.stub :get_vault, @response do
      assert_instance_of Fog::KeyVault::AzureRM::Vault, @vaults.get('fog-test-rg', 'fog-test-kv')
    end
  end

  def test_check_vault_exists_true_response
    @service.stub :check_vault_exists, true do
      assert @vaults.check_vault_exists('fog-test-rg', 'fog-test-kv')
    end
  end

  def test_check_vault_exists_false_response
    @service.stub :check_vault_exists, false do
      assert !@vaults.check_vault_exists('fog-test-rg', 'fog-test-kv')
    end
  end
end
