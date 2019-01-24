require File.expand_path '../../test_helper', __dir__

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
    @disks = @compute_client.disks
    @get_managed_disk_response = ApiStub::Requests::Compute::VirtualMachine.get_managed_disk_response(@compute_client)
    @get_vm_managed_disk_response = ApiStub::Requests::Compute::VirtualMachine.get_vm_with_managed_disk_response(@compute_client)
    @input_params = { vm_name: 'fog-test-vm', vm_resource_group: 'fog-test-rg', disk_name: 'disk1', disk_size_gb: 1, storage_account_name: 'mystorage1' }
  end

  def test_attach_data_disk_to_vm_success
    blob_service = Minitest::Mock.new
    blob_service.expect :get_blob_properties, 'blob_props' do
      Azure::Storage::Blob::BlobService.stub :new, blob_service do
        @virtual_machines.stub :get, @get_vm_response do
          @storage_accounts.stub :list_keys, @storage_access_keys_response do
            @virtual_machines.stub :create_or_update, @update_vm_response do
              assert_equal @service.attach_data_disk_to_vm(@input_params, false), @update_vm_response
              blob_service.verify
            end
          end
        end
      end
    end
  end

  def test_attach_managed_disk_to_vm_success
    @virtual_machines.stub :get, @get_vm_response do
      @disks.stub :get, @get_managed_disk_response do
        @virtual_machines.stub :create_or_update, @get_vm_managed_disk_response do
          input_params = { vm_name: 'ManagedVM', vm_resource_group: 'ManagedRG', disk_name: 'ManagedDataDisk1', disk_size_gb: 100, disk_resource_group: 'ManagedRG' }
          assert_equal @service.attach_data_disk_to_vm(input_params, false), @get_vm_managed_disk_response
        end
      end
    end
  end

  def test_attach_data_disk_to_vm_failure
    get_vm_response = ApiStub::Requests::Compute::VirtualMachine.virtual_machine_15_data_disks_response(@compute_client)
    @virtual_machines.stub :get, get_vm_response do
      @storage_accounts.stub :list_keys, @storage_access_keys_response do
        @virtual_machines.stub :create_or_update, @update_vm_response do
          assert_raises RuntimeError do
            @service.attach_data_disk_to_vm(@input_params, false)
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
          assert_raises Azure::Core::Http::HTTPError do
            @service.attach_data_disk_to_vm(@input_params, false)
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
          assert_raises Azure::Core::Http::HTTPError do
            @service.attach_data_disk_to_vm(@input_params, false)
          end
        end
      end
    end
  end

  def test_get_vm_failure
    get_vm_response = proc { fail MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @virtual_machines.stub :get, get_vm_response do
      assert_raises MsRestAzure::AzureOperationError do
        @service.attach_data_disk_to_vm(@input_params, false)
      end
    end
  end

  def test_get_storage_key_failure
    storage_access_keys_response = proc { fail MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @virtual_machines.stub :get, @get_vm_response do
      @storage_accounts.stub :list_keys, storage_access_keys_response do
        assert_raises MsRestAzure::AzureOperationError do
          @service.attach_data_disk_to_vm(@input_params, false)
        end
      end
    end
  end

  def test_detach_multiple_data_disks_from_vm_success
    @virtual_machines.stub :get, @get_vm_response do
      @disks.stub :get, @get_managed_disk_response do
        @virtual_machines.stub :create_or_update, @get_vm_managed_disk_response do
          input_params = { vm_name: 'fog-test-vm', vm_resource_group: 'fog-test-rg', disk_name: %w(mydatadisk1 mydatadisk2), disk_size_gb: nil, storage_account_name: nil }
          assert_equal @service.attach_data_disk_to_vm(input_params, false), @get_vm_managed_disk_response
        end
      end
    end
  end
end
