require File.expand_path '../../test_helper', __dir__

# Test class for Availability Set Collection
class TestStorageAccounts < Minitest::Test
  def setup
    @service = Fog::Storage::AzureRM.new(credentials)
    @client = @service.instance_variable_get(:@storage_mgmt_client)
    @storage_accounts = Fog::Storage::AzureRM::StorageAccounts.new(resource_group: 'fog-test-rg', service: @service)
    @list_storage_account_response = [ApiStub::Models::Storage::StorageAccount.create_storage_account(@client)]
  end

  def test_collection_methods
    methods = [
      :all,
      :get
    ]
    methods.each do |method|
      assert @storage_accounts.respond_to? method, true
    end
  end

  def test_collection_attributes
    assert @storage_accounts.respond_to? :resource_group, true
  end

  def test_all_method_response_for_rg
    @service.stub :list_storage_account_for_rg, @list_storage_account_response do
      assert_instance_of Fog::Storage::AzureRM::StorageAccounts, @storage_accounts.all
      assert @storage_accounts.all.size >= 1
      @storage_accounts.all.each do |s|
        assert_instance_of Fog::Storage::AzureRM::StorageAccount, s
      end
    end
  end

  def test_all_method_response
    storage_accounts = Fog::Storage::AzureRM::StorageAccounts.new(service: @service)
    @service.stub :list_storage_accounts, @list_storage_account_response do
      assert_instance_of Fog::Storage::AzureRM::StorageAccounts, storage_accounts.all
      assert storage_accounts.all.size >= 1
      storage_accounts.all.each do |s|
        assert_instance_of Fog::Storage::AzureRM::StorageAccount, s
      end
    end
  end

  def test_get_method_response
    @service.stub :list_storage_account_for_rg, @list_storage_account_response do
      assert_instance_of Fog::Storage::AzureRM::StorageAccount, @storage_accounts.get('fog-test-storage-account')
      assert @storage_accounts.get('wrong-name').nil?, true
    end
  end

  def test_check_name_availability_true_case
    @service.stub :check_storage_account_name_availability, true do
      assert @storage_accounts.check_name_availability('fog-test-storage-account')
    end
  end

  def test_check_name_availability_false_case
    @service.stub :check_storage_account_name_availability, false do
      assert !@storage_accounts.check_name_availability('fog-test-storage-account')
    end
  end
end
