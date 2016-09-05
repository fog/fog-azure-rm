require File.expand_path '../../test_helper', __dir__

# Test class for Create Virtual Machine Request
class TestCreateVirtualMachine < Minitest::Test
  def setup
    @service = Fog::Compute::AzureRM.new(credentials)
    compute_client = @service.instance_variable_get(:@compute_mgmt_client)
    @virtual_machines = compute_client.virtual_machines
    @linux_virtual_machine_hash = ApiStub::Requests::Compute::VirtualMachine.linux_virtual_machine_hash
    @windows_virtual_machine_hash = ApiStub::Requests::Compute::VirtualMachine.windows_virtual_machine_hash
    @response = ApiStub::Requests::Compute::VirtualMachine.create_virtual_machine_response(compute_client)
  end

  def test_create_linux_virtual_machine_success
    @virtual_machines.stub :create_or_update, @response do
      assert_equal @service.create_virtual_machine(@linux_virtual_machine_hash), @response
    end
  end

  def test_create_windows_virtual_machine_success
    @virtual_machines.stub :create_or_update, @response do
      assert_equal @service.create_virtual_machine(@windows_virtual_machine_hash), @response
    end
  end

  def test_create_virtual_machine_failure
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @virtual_machines.stub :create_or_update, response do
      assert_raises RuntimeError do
        @service.create_virtual_machine(@linux_virtual_machine_hash)
      end
    end
  end
end
