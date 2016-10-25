require File.expand_path '../../test_helper', __dir__

# Test Class for RecoveryVault Collections
class TestRecoveryVaults < Minitest::Test
  def setup
    @service = Fog::Storage::AzureRM.new(credentials)
    @recovery_vaults = Fog::Storage::AzureRM::RecoveryVaults.new(resource_group: 'fog-test-rg', service: @service)
  end

  def test_collection_methods
    methods = [
      :all,
      :get
    ]
    methods.each do |method|
      assert_respond_to @recovery_vaults, method
    end
  end

  def test_collection_attributes
    attributes = [
      :resource_group,
      :name
    ]
    attributes.each do |attribute|
      assert_respond_to @recovery_vaults, attribute
    end
  end

  def test_all_method_response
    response = [ApiStub::Models::Storage::RecoveryVault.create_method_response]
    @service.stub :list_recovery_vaults, response do
      assert_instance_of Fog::Storage::AzureRM::RecoveryVaults, @recovery_vaults.all
      assert @recovery_vaults.all.size >= 1
      @recovery_vaults.all.each do |recovery_vault|
        assert_instance_of Fog::Storage::AzureRM::RecoveryVault, recovery_vault
      end
    end
  end

  def test_get_method_response
    response = ApiStub::Models::Storage::RecoveryVault.create_method_response
    @service.stub :get_recovery_vault, response do
      assert_instance_of Fog::Storage::AzureRM::RecoveryVault, @recovery_vaults.get('fog-test-rg', 'fog-test-vault')
    end
  end
end
