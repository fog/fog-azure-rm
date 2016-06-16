require File.expand_path '../../test_helper', __dir__

# Test class for Detach Data Disk from VM Request
class TestDetachDataDiskFromVM < Minitest::Test
  def setup
    @service = Fog::Compute::AzureRM.new(credentials)
    vm_client = @service.instance_variable_get(:@compute_mgmt_client)
    @virtual_machines = vm_client.virtual_machines
  end

  def test_detach_data_disk_from_vm_success
    promise_get_vm = Concurrent::Promise.execute do
    end

    promise_update_vm = Concurrent::Promise.execute do
    end

    get_vm_response = ApiStub::Requests::Compute::VirtualMachine.create_virtual_machine_response
    update_vm_response = ApiStub::Requests::Compute::VirtualMachine.detach_data_disk_from_vm_response
    expected_update_vm_response = Azure::ARM::Compute::Models::VirtualMachine.serialize_object(update_vm_response.body)
    promise_get_vm.stub :value!, get_vm_response do
      @virtual_machines.stub :get, promise_get_vm do
        promise_update_vm.stub :value!, update_vm_response do
          @virtual_machines.stub :create_or_update, promise_update_vm do
            assert_equal @service.detach_data_disk_from_vm('fog-test-rg', 'fog-test-vm', 'mydatadisk1'), expected_update_vm_response
          end
        end
      end
    end
  end

  def test_detach_data_disk_from_vm_failure
    promise_get_vm = Concurrent::Promise.execute do
    end

    promise_update_vm = Concurrent::Promise.execute do
    end

    get_vm_response = ApiStub::Requests::Compute::VirtualMachine.create_virtual_machine_response
    update_vm_response = -> { fail MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    promise_get_vm.stub :value!, get_vm_response do
      @virtual_machines.stub :get, promise_get_vm do
        promise_update_vm.stub :value!, update_vm_response do
          @virtual_machines.stub :create_or_update, promise_update_vm do
            assert_raises RuntimeError do
              @service.detach_data_disk_from_vm('fog-test-rg', 'fog-test-vm', 'mydatadisk1')
            end
          end
        end
      end
    end
  end
end
