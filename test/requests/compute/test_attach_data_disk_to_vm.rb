require File.expand_path '../../test_helper', __dir__

# Test class for Attach Data Disk to VM Request
class TestAttachDataDiskToVM < Minitest::Test
  def setup
    @service = Fog::Compute::AzureRM.new(credentials)
    vm_client = @service.instance_variable_get(:@compute_mgmt_client)
    storage_client = @service.instance_variable_get(:@storage_mgmt_client)
    @virtual_machines = vm_client.virtual_machines
    @storage_accounts = storage_client.storage_accounts
  end

  def test_attach_data_disk_to_vm_success
    promise_get_vm = Concurrent::Promise.execute do
    end

    promise_update_vm = Concurrent::Promise.execute do
    end

    promise_storage_access_keys = Concurrent::Promise.execute do
    end

    get_vm_response = ApiStub::Requests::Compute::VirtualMachine.create_virtual_machine_response
    update_vm_response = ApiStub::Requests::Compute::VirtualMachine.update_virtual_machine_response
    expected_update_vm_response = Azure::ARM::Compute::Models::VirtualMachine.serialize_object(update_vm_response.body)
    storage_access_keys_response = ApiStub::Requests::Storage::StorageAccount.list_keys_response
    promise_get_vm.stub :value!, get_vm_response do
      @virtual_machines.stub :get, promise_get_vm do
        promise_storage_access_keys.stub :value!, storage_access_keys_response do
          @storage_accounts.stub :list_keys, promise_storage_access_keys do
            promise_update_vm.stub :value!, update_vm_response do
              @virtual_machines.stub :create_or_update, promise_update_vm do
                @service.stub :check_blob_exist, true do
                  assert_equal @service.attach_data_disk_to_vm('fog-test-rg', 'fog-test-vm', 'disk1', 1, 'mystorage1'), expected_update_vm_response
                end
              end
            end
          end
        end
      end
    end
  end

  def test_attach_data_disk_to_vm_failure
    promise_get_vm = Concurrent::Promise.execute do
    end

    promise_update_vm = Concurrent::Promise.execute do
    end

    promise_storage_access_keys = Concurrent::Promise.execute do
    end

    get_vm_response = ApiStub::Requests::Compute::VirtualMachine.virtual_machine_15_data_disks_response
    update_vm_response = ApiStub::Requests::Compute::VirtualMachine.update_virtual_machine_response
    storage_access_keys_response = ApiStub::Requests::Storage::StorageAccount.list_keys_response
    promise_get_vm.stub :value!, get_vm_response do
      @virtual_machines.stub :get, promise_get_vm do
        promise_storage_access_keys.stub :value!, storage_access_keys_response do
          @storage_accounts.stub :list_keys, promise_storage_access_keys do
            promise_update_vm.stub :value!, update_vm_response do
              @virtual_machines.stub :create_or_update, promise_update_vm do
                @service.stub :check_blob_exist, true do
                  assert_raises RuntimeError do
                    @service.attach_data_disk_to_vm('fog-test-rg', 'fog-test-vm', 'disk1', 1, 'mystorage1')
                  end
                end
              end
            end
          end
        end
      end
    end
  end

  def test_update_vm_failure
    promise_get_vm = Concurrent::Promise.execute do
    end

    promise_update_vm = Concurrent::Promise.execute do
    end

    promise_storage_access_keys = Concurrent::Promise.execute do
    end

    get_vm_response = ApiStub::Requests::Compute::VirtualMachine.create_virtual_machine_response
    update_vm_response = -> { fail MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    storage_access_keys_response = ApiStub::Requests::Storage::StorageAccount.list_keys_response
    promise_get_vm.stub :value!, get_vm_response do
      @virtual_machines.stub :get, promise_get_vm do
        promise_storage_access_keys.stub :value!, storage_access_keys_response do
          @storage_accounts.stub :list_keys, promise_storage_access_keys do
            promise_update_vm.stub :value!, update_vm_response do
              @virtual_machines.stub :create_or_update, promise_update_vm do
                @service.stub :check_blob_exist, true do
                  assert_raises RuntimeError do
                    @service.attach_data_disk_to_vm('fog-test-rg', 'fog-test-vm', 'disk1', 1, 'mystorage1')
                  end
                end
              end
            end
          end
        end
      end
    end
  end

  def test_update_vm_blob_not_exist_failure
    promise_get_vm = Concurrent::Promise.execute do
    end

    promise_update_vm = Concurrent::Promise.execute do
    end

    promise_storage_access_keys = Concurrent::Promise.execute do
    end

    get_vm_response = ApiStub::Requests::Compute::VirtualMachine.create_virtual_machine_response
    update_vm_response = -> { fail MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    storage_access_keys_response = ApiStub::Requests::Storage::StorageAccount.list_keys_response
    promise_get_vm.stub :value!, get_vm_response do
      @virtual_machines.stub :get, promise_get_vm do
        promise_storage_access_keys.stub :value!, storage_access_keys_response do
          @storage_accounts.stub :list_keys, promise_storage_access_keys do
            promise_update_vm.stub :value!, update_vm_response do
              @virtual_machines.stub :create_or_update, promise_update_vm do
                @service.stub :check_blob_exist, false do
                  assert_raises RuntimeError do
                    @service.attach_data_disk_to_vm('fog-test-rg', 'fog-test-vm', 'disk1', 1, 'mystorage1')
                  end
                end
              end
            end
          end
        end
      end
    end
  end

  def test_get_vm_failure
    promise_get_vm = Concurrent::Promise.execute do
    end

    get_vm_response = -> { fail MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    promise_get_vm.stub :value!, get_vm_response do
      @virtual_machines.stub :get, promise_get_vm do
        assert_raises RuntimeError do
          @service.attach_data_disk_to_vm('fog-test-rg', 'fog-test-vm', 'disk1', 1, 'mystorage1')
        end
      end
    end
  end

  def test_get_storage_key_failure
    promise_get_vm = Concurrent::Promise.execute do
    end

    promise_storage_access_keys = Concurrent::Promise.execute do
    end

    get_vm_response = ApiStub::Requests::Compute::VirtualMachine.create_virtual_machine_response
    storage_access_keys_response = -> { fail MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    promise_get_vm.stub :value!, get_vm_response do
      @virtual_machines.stub :get, promise_get_vm do
        promise_storage_access_keys.stub :value!, storage_access_keys_response do
          @storage_accounts.stub :list_keys, promise_storage_access_keys do
            assert_raises RuntimeError do
              @service.attach_data_disk_to_vm('fog-test-rg', 'fog-test-vm', 'disk1', 1, 'mystorage1')
            end
          end
        end
      end
    end
  end
end
