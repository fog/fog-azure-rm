require File.expand_path '../../../test_helper', __FILE__

# Test class for Attach Data Disk to VM Request
class TestAttachDataDiskToVM < Minitest::Test
  def setup
    @service = Fog::Compute::AzureRM.new(credentials)
    @compute_client = @service.instance_variable_get(:@compute_mgmt_client)
    storage_client = @service.instance_variable_get(:@storage_mgmt_client)
    @virtual_machines = @compute_client.virtual_machines
    @storage_accounts = storage_client.storage_accounts
    @get_vm_response = ApiStub::Requests::Compute::VirtualMachine.create_virtual_machine_response(@compute_client)
    @update_vm_response = ApiStub::Requests::Compute::VirtualMachine.update_virtual_machine_response(@compute_client)
    @storage_access_keys_response = ApiStub::Requests::Storage::StorageAccount.list_keys_response
  end

  def test_attach_data_disk_to_vm_success
    @virtual_machines.stub :get, @get_vm_response do
      @storage_accounts.stub :list_keys, @storage_access_keys_response do
        @virtual_machines.stub :create_or_update, @update_vm_response do
          @service.stub :check_blob_exist, true do
            assert_equal @service.attach_data_disk_to_vm('fog-test-rg', 'fog-test-vm', 'disk1', 1, 'mystorage1'), @update_vm_response
          end
        end
      end
    end
  end

  def test_attach_data_disk_to_vm_failure
    get_vm_response = ApiStub::Requests::Compute::VirtualMachine.virtual_machine_15_data_disks_response(@compute_client)
    @virtual_machines.stub :get, get_vm_response do
      @storage_accounts.stub :list_keys, @storage_access_keys_response do
        @virtual_machines.stub :create_or_update, @update_vm_response do
          @service.stub :check_blob_exist, true do
            assert_raises RuntimeError do
              @service.attach_data_disk_to_vm('fog-test-rg', 'fog-test-vm', 'disk1', 1, 'mystorage1')
            end
          end
        end
      end
    end
  end

  def test_update_vm_failure
    update_vm_response = proc { fail MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @virtual_machines.stub :get, @get_vm_response do
      @storage_accounts.stub :list_keys, @storage_access_keys_response do
        @virtual_machines.stub :create_or_update, update_vm_response do
          @service.stub :check_blob_exist, true do
            assert_raises RuntimeError do
              @service.attach_data_disk_to_vm('fog-test-rg', 'fog-test-vm', 'disk1', 1, 'mystorage1')
            end
          end
        end
      end
    end
  end

  def test_update_vm_blob_not_exist_failure
    update_vm_response = proc { fail MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @virtual_machines.stub :get, @get_vm_response do
      @storage_accounts.stub :list_keys, @storage_access_keys_response do
        @virtual_machines.stub :create_or_update, update_vm_response do
          @service.stub :check_blob_exist, false do
            assert_raises RuntimeError do
              @service.attach_data_disk_to_vm('fog-test-rg', 'fog-test-vm', 'disk1', 1, 'mystorage1')
            end
          end
        end
      end
    end
  end

  def test_get_vm_failure
    get_vm_response = proc { fail MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @virtual_machines.stub :get, get_vm_response do
      assert_raises RuntimeError do
        @service.attach_data_disk_to_vm('fog-test-rg', 'fog-test-vm', 'disk1', 1, 'mystorage1')
      end
    end
  end

  def test_get_storage_key_failure
    storage_access_keys_response = proc { fail MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @virtual_machines.stub :get, @get_vm_response do
      @storage_accounts.stub :list_keys, storage_access_keys_response do
        assert_raises RuntimeError do
          @service.attach_data_disk_to_vm('fog-test-rg', 'fog-test-vm', 'disk1', 1, 'mystorage1')
        end
      end
    end
  end
end
