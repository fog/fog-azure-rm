require File.expand_path '../../test_helper', __dir__

# Test class for Vault Model
class TestVault < Minitest::Test
  def setup
    @service = Fog::KeyVault::AzureRM.new(credentials)
    @vault = key_vault(@service)
  end

  def test_model_attributes
    attributes = [
      :name,
      :id,
      :resource_group,
      :location,
      :vault_uri,
      :tenant_id,
      :sku_family,
      :sku_name,
      :access_policies,
      :enabled_for_deployment,
      :enabled_for_disk_encryption,
      :enabled_for_template_deployment,
      :tags
    ]
    attributes.each do |attribute|
      assert_respond_to @vault, attribute
    end
  end

  def test_model_methods
    methods = [
      :save,
      :destroy
    ]
    methods.each do |method|
      assert_respond_to @vault, method
    end
  end
end
