require File.expand_path '../../test_helper', __dir__

# Test class for Recovery Vault model
class TestRecoveryVault < Minitest::Test
  def setup
    @service = Fog::Storage::AzureRM.new(credentials)
    @recovery_vault = recovery_vault(@service)
  end

  def test_model_methods
    methods = [
      :save,
      :enable_backup_protection,
      :disable_backup_protection,
      :start_backup,
      :destroy
    ]
    methods.each do |method|
      assert_respond_to @recovery_vault, method
    end
  end

  def test_model_attributes
    attributes = [
      :id,
      :name,
      :resource_group,
      :location,
      :type,
      :sku_name
    ]
    attributes.each do |attribute|
      assert_respond_to @recovery_vault, attribute
    end
  end

  def test_save_method_response
    create_response = ApiStub::Models::Storage::RecoveryVault.create_method_response
    @service.stub :create_or_update_recovery_vault, create_response do
      assert_instance_of Fog::Storage::AzureRM::RecoveryVault, @recovery_vault.save
    end
  end

  def test_enable_backup_protection_method_response
    @service.stub :enable_backup_protection, true do
      assert @recovery_vault.enable_backup_protection('test-vm', 'test-vm-rg')
    end
  end

  def test_disable_backup_protection_method_response
    @service.stub :disable_backup_protection, true do
      assert @recovery_vault.disable_backup_protection('test-vm', 'test-vm-rg')
    end
  end

  def test_destroy_method_response
    @service.stub :delete_recovery_vault, true do
      assert @recovery_vault.destroy
    end
  end
end
