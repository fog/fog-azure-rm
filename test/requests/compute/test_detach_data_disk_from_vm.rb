require File.expand_path '../../test_helper', __dir__

# Test class for Detach Data Disk from VM Request
class TestDetachDataDiskFromVM < Minitest::Test
  def setup
    @service = Fog::Compute::AzureRM.new(credentials)
    @compute_client = @service.instance_variable_get(:@compute_mgmt_client)
    @virtual_machines = @compute_client.virtual_machines
  end

  def test_detach_data_disk_from_vm_success
    get_vm_response = ApiStub::Requests::Compute::VirtualMachine.create_virtual_machine_response(@compute_client)
    update_vm_response = ApiStub::Requests::Compute::VirtualMachine.detach_data_disk_from_vm_response(@compute_client)
    @virtual_machines.stub :get, get_vm_response do
      @virtual_machines.stub :create_or_update, update_vm_response do
        assert_equal @service.detach_data_disk_from_vm('fog-test-rg', 'fog-test-vm', 'mydatadisk1', false), update_vm_response
      end
    end
  end

  def test_detach_multiple_data_disks_from_vm_success
    get_vm_response = ApiStub::Requests::Compute::VirtualMachine.create_virtual_machine_response(@compute_client)
    update_vm_response = ApiStub::Requests::Compute::VirtualMachine.detach_data_disk_from_vm_response(@compute_client)
    @virtual_machines.stub :get, get_vm_response do
      @virtual_machines.stub :create_or_update, update_vm_response do
        assert_equal @service.detach_data_disk_from_vm('fog-test-rg', 'fog-test-vm', %w(mydatadisk1 mydatadisk2), false), update_vm_response
      end
    end
  end

  def test_detach_data_disk_from_vm_failure
    get_vm_response = ApiStub::Requests::Compute::VirtualMachine.create_virtual_machine_response(@compute_client)
    update_vm_response = proc { fail MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @virtual_machines.stub :get, get_vm_response do
      @virtual_machines.stub :create_or_update, update_vm_response do
        assert_raises MsRestAzure::AzureOperationError do
          @service.detach_data_disk_from_vm('fog-test-rg', 'fog-test-vm', 'mydatadisk1', false)
        end
      end
    end
  end
end
